#include "PackMLModule.hpp"


		// -----------------------------------------------------------------------------

PackMLModule::PackMLModule(const char* pModuleName) : moduleName_(pModuleName),
	moduleId_(0),
	semaphore_(),
	activationCondition_(0),
	overrideAbort_(false),
	overrideStop_(false),
	overrideClear_(false),
	overrideReset_(false),
	overrideStart_(false),
	overrideSuspend_(false),
	overrideUnsuspend_(false),
	overrideHold_(false),
	overrideUnhold_(false),
	overrideComplete_(false),
	reactToAbort_(false),
	reactToStop_(false),
	reactToClear_(false),
	reactToReset_(false),
	reactToStart_(false),
	reactToSuspend_(false),
	reactToUnsuspend_(false),
	reactToHold_(false),
	reactToUnhold_(false),
	reactToComplete_(false),
	escalateAbort_(false),
	escalateStop_(false),
	escalateClear_(false),
	escalateReset_(false),
	escalateStart_(false),
	escalateSuspend_(false),
	escalateUnsuspend_(false),
	escalateHold_(false),
	escalateUnhold_(false),
	escalateComplete_(false),	
	pParentLink_(nullptr),
	childLinks_(),
	parentLinkAdr_(0),
	hasParent_(false),
	childCount_(0),
	hierarchyLevel_(0),
	moduleReady_(false),
	modeCurrent_(1),
	stateCurrent_(ST_UNDEFINED),
	subStateCurrent_(0),
	activate_(false),
	deactivate_(false),
	abort_(false),
	clear_(false),
	stop_(false),
	reset_(false),
	start_(false),
	hold_(false),
	unhold_(false),
	suspend_(false),
	unsuspend_(false),
	complete_(false),
	stateComplete_(false),
	oldAbort_(false),
	oldClear_(false),
	oldStop_(false),
	oldReset_(false),
	oldStart_(false),
	oldHold_(false),
	oldUnhold_(false),
	oldSuspend_(false),
	oldUnsuspend_(false),
	oldComplete_(false),
	oldStateComplete_(false),
	externalAbort_(false),
	externalClear_(false),
	externalStop_(false),
	externalReset_(false),
	externalStart_(false),
	externalHold_(false),
	externalUnhold_(false),
	externalSuspend_(false),
	externalUnsuspend_(false),
	externalComplete_(false),
	externalStateComplete_(false),
	pWaitingFor_(nullptr),
	pInteruptedBy_(nullptr),
	activationPv_(false),
	timeInState_(0.0),
	timeInSubState_(0.0),
	cycleTime_(0.0),
	pUserData_(nullptr),
	userDataSize_(0)
{
	//	moduleName_ = "";
	stateInfo_ = "";
	moduleId_ = generateId_(pModuleName);

}

		// -----------------------------------------------------------------------------

PackMLModule::~PackMLModule()
{
	free(pUserData_);
}

// -----------------------------------------------------------------------------
void* PackMLModule::createUserMemory(unsigned long int userMemorySize){
	if(pUserData_ != nullptr)
		return pUserData_;
	
	pUserData_ = calloc(userMemorySize, sizeof(char));
	userDataSize_ = userMemorySize;
//	memset(pUserData_, 0, userDataSize_);
	
	return pUserData_;
}
// -----------------------------------------------------------------------------
void* PackMLModule::getUserMemoryPtr(){
	return pUserData_;
}

void PackMLModule::deleteUserMemory(){
	free(pUserData_);
}

// -----------------------------------------------------------------------------

void PackMLModule::initModule()
{
	setNewModeCurrent(modeCurrent_);
	setHierarchyLevel(0);
	
	if(pWaitingFor_ == nullptr)
		pWaitingFor_ = new PackMLModuleSharedInfo();
	if(pInteruptedBy_ == nullptr)
		pInteruptedBy_ = new PackMLModuleSharedInfo();

	setSharedInfoPtrs(pWaitingFor_, pInteruptedBy_);
	setModuleReady(true);

}
		
bool PackMLModule::initModule(PackMLModule* pParent)
{	
	if(pParent == nullptr || pParent == this || isChild_(pParent)){
		return false;
	}
	return linkToParent_(pParent);
}

		// -----------------------------------------------------------------------------
bool PackMLModule::exitModule()
{	
	// decide what to do here, do we need to reset those when unlinking from parent
	resetWaitingFor_();
	resetInteruptedBy_();
	
	// ******
	// nested call for resetWaitingFor and InteruptedBy for all children and childrens children
	// ******
	
	setNewModeCurrent(modeCurrent_);
	setHierarchyLevel(0);
	setModuleReady(false);
	
	stateInfo_ = "";
	
	overrideAbort_ = false;
	overrideStop_ = false;
	overrideClear_ = false;
	overrideReset_ = false;
	overrideStart_ = false;
	overrideSuspend_ = false;
	overrideUnsuspend_ = false;
	overrideHold_ = false;
	overrideUnhold_ = false;
	overrideComplete_ = false;
	reactToAbort_ = false;
	reactToStop_ = false;
	reactToClear_ = false;
	reactToReset_ = false;
	reactToStart_ = false;
	reactToSuspend_ = false;
	reactToUnsuspend_ = false;
	reactToHold_ = false;
	reactToUnhold_ = false;
	reactToComplete_ = false;
	escalateAbort_ = false;
	escalateStop_ = false;
	escalateClear_ = false;
	escalateReset_ = false;
	escalateStart_ = false;
	escalateSuspend_ = false;
	escalateUnsuspend_ = false;
	escalateHold_ = false;
	escalateUnhold_ = false;
	escalateComplete_ = false;
	activate_ = false;
	deactivate_ = false;

	
	resetInternalCmds_();
			
	if(!hasParent_){
		delete pWaitingFor_;
		delete pInteruptedBy_;
		setSharedInfoPtrs(nullptr, nullptr);
		return true;
	}
	
	setSharedInfoPtrs(nullptr, nullptr);
	return unlinkFromParent_();
}

		// -----------------------------------------------------------------------------

void PackMLModule::runPackMLModule()
{
	updateTimeInState_();
	// check parent state condition
	checkParentStateCondition_();
	// update the packml model
	updatePackMLModel_();

}
		// ---------------------------------------------------------------------------

		// called during onCreated() if parent found and in onService()
bool PackMLModule::linkToParent_(PackMLModule* pParent)
{
	if(pParent->registerChild(this)){
		pParentLink_ = pParent;
		hasParent_ = true;
		return true;
	}
	return false;
}

		// -------------------------------------------------------------------------
		
bool PackMLModule::unlinkFromParent_()
{
	if(pParentLink_->unregisterChild(this)){
		pParentLink_ = nullptr;
		hasParent_ = false;
		return true;
	}
	return false;
}
		
		// -------------------------------------------------------------------------

bool PackMLModule::registerChild(PackMLModule* pChild)
{
	
	if(isChild_(pChild))
		return true;
	
	if(!semaphore_.acquire())
		return false;

	childLinks_.push_back(pChild);

	pChild->setNewModeCurrent(modeCurrent_);
	pChild->setHierarchyLevel(hierarchyLevel_ + 1);
	pChild->setSharedInfoPtrs(pWaitingFor_, pInteruptedBy_);
	pChild->setModuleReady(moduleReady_);

	childCount_ = childLinks_.size();
	semaphore_.release();
	return true;
}

		// -------------------------------------------------------------------------

bool PackMLModule::unregisterChild(PackMLModule* pChild)
{
	//			BR::Core::MutexLocker lock(&mutex_);
			
	if(!semaphore_.acquire())
		return false;

	for (unsigned short i = 0; i < childCount_; ++i) {
		if (childLinks_[i]->getModuleId() == pChild->getModuleId()) {
			childLinks_.erase(childLinks_.begin() + i);
			break;
		}
	}
			
	childCount_ = childLinks_.size();
	semaphore_.release();
	return true;
}

		// -------------------------------------------------------------------------

void PackMLModule::setModuleReady(bool value)
{
	moduleReady_ = value;

	if (moduleReady_) {
		stateCurrent_ = ST_DEACTIVATED;
	}
	else {
		stateCurrent_ = ST_UNDEFINED;
	}

	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->setModuleReady(value);
	}
}


void PackMLModule::setHierarchyLevel(unsigned short level)
{
	hierarchyLevel_ = level;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->setHierarchyLevel(level + 1);
	}

}

void PackMLModule::setAllStateComplete()
{
	stateComplete_ = true;
	externalStateComplete_ = stateComplete_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->setAllStateComplete();
	}

}

void PackMLModule::setSharedInfoPtrs(PackMLModuleSharedInfo* pWaitingFor, PackMLModuleSharedInfo* pInteruptedBy)
{
	pWaitingFor_ = pWaitingFor;
	pInteruptedBy_ = pInteruptedBy;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->setSharedInfoPtrs(pWaitingFor_, pInteruptedBy_);
	}

}

		// -------------------------------------------------------------------------


unsigned long PackMLModule::generateId_(const char *pName)
{
	unsigned long int N = strlen(pName);
	unsigned long int b    = 378551;
	unsigned long int a    = 63689;
	unsigned long int hash = 0;

	for(std::size_t i = 0; i < N; i++)
	{
		hash = hash * a + pName[i];
		a    = a * b;
	}

	return (hash & 0x7FFFFFFF);
}

