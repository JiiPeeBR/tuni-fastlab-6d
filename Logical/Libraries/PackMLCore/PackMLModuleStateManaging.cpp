#include "PackMLModule.hpp"

		// -----------------------------------------------------------------------------

const char *internalInfoStateNames[] = { "Undefined",
	"Clearing",
	"Stopped",
	"Starting",
	"Idle",
	"Suspended",
	"Execute",
	"Stopping",
	"Aborting",
	"Aborted",
	"Holding",
	"Held",
	"Unholding",
	"Suspending",
	"Unsuspending",
	"Resetting",
	"Completing",
	"Completed",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"Deactivating",
	"Deactivated",
	"Activating" };
		
const char *internalInfoModeNames[] = { "Undefined",
	"Production",
	"Maintenance",
	"Manual",
	""};

		// -----------------------------------------------------------------------------
		// we need to add complete cmd to the pattern
const unsigned long CMD_VALID_BIT_PATTERN_LIST[]
	= { 0,          0x00000080, 0x20004080, 0x000000C0, 0x000000C4, 0x0000A2C0,
	0x000092C0, 0x00000080, 0,          0x20000001, 0x000000C0, 0x000088C0,
	0x000000C0, 0x000000C0, 0x000000C0, 0x000000C0, 0x000000C0, 0x000040C0,
	0,          0,          0,          0,          0,          0,
	0,          0,          0,          0,          0,          0,
	0,          0x80000000, 0 };

// -----------------------------------------------------------------------------

PackMLModule* PackMLModule::getParentPtr(){
	if (!hasParent_)
		return nullptr;
	
	return pParentLink_;
}
// -----------------------------------------------------------------------------
PackMLModule* PackMLModule::getChildPtr(unsigned long int childIdx){
	if(childCount_ <= 0)
		return nullptr;
	
	return childLinks_[childIdx % childCount_];
}
// -----------------------------------------------------------------------------
PackMLModule* PackMLModule::getSiblingPtr(unsigned long int siblingIdx){
	if (!hasParent_)
		return nullptr;
	
	return pParentLink_->getChildPtr(siblingIdx);
}
// -----------------------------------------------------------------------------



PackMLModuleStateEnu PackMLModule::getChildCurrentState(unsigned long int childIndex){
	if(childCount_ <= 0)
		return ST_UNDEFINED;
	
	return childLinks_[childIndex % childCount_]->getCurrentState();
}
		// -----------------------------------------------------------------------------
long int PackMLModule::getChildCurrentSubState(unsigned long int childIndex){
	if(childCount_ <= 0)
		return 0;
	
	return childLinks_[childIndex % childCount_]->getCurrentSubState();
}
		// -----------------------------------------------------------------------------
bool PackMLModule::getChildStateComplete(unsigned long int childIndex){
	if(childCount_ <= 0)
		return false;
	
	return childLinks_[childIndex % childCount_]->getStateComplete();
}
		// -----------------------------------------------------------------------------
const char* PackMLModule::getChildName(unsigned long int childIndex){
	if(childCount_ <= 0)
		return "";
	
	return childLinks_[childIndex % childCount_]->getModuleName();
}
		// -----------------------------------------------------------------------------
PackMLModuleStateEnu PackMLModule::getSiblingCurrentState(unsigned long int siblingIndex){
	if (!hasParent_)
		return ST_UNDEFINED;
	
	return pParentLink_->getChildCurrentState(siblingIndex);
}
		// -----------------------------------------------------------------------------
long int PackMLModule::getSiblingCurrentSubState(unsigned long int siblingIndex){
	if (!hasParent_)
		return 0;
	
	return pParentLink_->getChildCurrentSubState(siblingIndex);
}
		// -----------------------------------------------------------------------------
bool PackMLModule::getSiblingStateComplete(unsigned long int siblingIndex){
	if (!hasParent_)
		return false;
	
	return pParentLink_->getChildStateComplete(siblingIndex);
}
		// -----------------------------------------------------------------------------
const char* PackMLModule::getSiblingName(unsigned long int siblingIndex){
	if (!hasParent_)
		return "";
	
	return pParentLink_->getChildName(siblingIndex);
}
		// -----------------------------------------------------------------------------
bool PackMLModule::isChild_(PackMLModule* pModule){
	for (unsigned short i = 0; i < childCount_; ++i) {
		if (childLinks_[i] == pModule) {
			return true;
		}
	}
	return false;
}
		// -----------------------------------------------------------------------------
unsigned long PackMLModule::getSiblingCount(){
	if (!hasParent_) {
		return 1;
	}
	return pParentLink_->getChildCount();	
}
		// -----------------------------------------------------------------------------
bool PackMLModule::getSiblingsStateComplete(){
	if (!hasParent_) {
		return stateComplete_;
	}
	return pParentLink_->getChildrenStateComplete();
}
	
		// -----------------------------------------------------------------------------
bool PackMLModule::getChildrenStateComplete(){
	for (unsigned short i = 0; i < childCount_; ++i) {
		if (!childLinks_[i]->getStateComplete()) {
			return false;
		}
	}
	return true;
}
		// -----------------------------------------------------------------------------
PackMLModuleStateEnu PackMLModule::getParentCurrentState()
{
	if (!hasParent_) {
		return ST_UNDEFINED;
	}
	return pParentLink_->getCurrentState();
}

		// -----------------------------------------------------------------------------

long int PackMLModule::getParentCurrentSubState()
{
	if (!hasParent_) {
		return 0;
	}
	return pParentLink_->getCurrentSubState();
}

		// -----------------------------------------------------------------------------

const char *PackMLModule::getParentName()
{
	if (!hasParent_) {
		return "";
	}
	return pParentLink_->getModuleName();
}
		
bool PackMLModule::getParentStateComplete()
{
	if (!hasParent_) {
		return true;
	}
	return pParentLink_->getStateComplete();
}

		// -----------------------------------------------------------------------------

const char *PackMLModule::getCurrentStateStr() const
{
	return internalInfoStateNames[stateCurrent_];

}

const char *PackMLModule::getStateStr(PackMLModuleStateEnu state) const
{
	return internalInfoStateNames[state];
}

		// -----------------------------------------------------------------------------


		// -----------------------------------------------------------------------------

const char* PackMLModule::getCurrentModeName() const
{
	return internalInfoModeNames[modeCurrent_];
}

const char* PackMLModule::getModeName(signed long int modeId) const
{
	return internalInfoModeNames[modeId];
}

		// -----------------------------------------------------------------------------
		
// --------------------------------------------------------------------------
		
void PackMLModule::setNewModeCurrent(long int mode)
{
	modeCurrent_ = mode;
			
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->setNewModeCurrent(modeCurrent_);
	}
}		

		// -----------------------------------------------------------------------------

bool PackMLModule::setCurrentMode(long int mode)
{
	
	// Check if the hierarchy is in synch
	if(!isModeChangePossible())
		return false;
		
	// update mode
	setNewModeCurrent(mode);
	// propagate mode to the children within one cycle
	return true;
}

		// -----------------------------------------------------------------------------

bool PackMLModule::isModeChangePossible()
{
	// What should the child do when it is not synchronised with the parent?
	if (!childrenInState_(stateCurrent_)) {
		return false;
	}

	for (unsigned short i = 0; i < childCount_; ++i) {
		if (!childLinks_[i]->isModeChangePossible()) {
			return false;
		}
	}

	return true;
}
		// -----------------------------------------------------------------------------

bool PackMLModule::childrenInState_(PackMLModuleStateEnu state)
{
			
	for (unsigned short i = 0; i < childCount_; ++i) {
		PackMLModuleStateEnu childState = childLinks_[i]->getCurrentState();
		if (childState != state && childState != ST_DEACTIVATED) {
			return false;
		}
	}
	return true;
}
		


		
		// -------------------------------------------------------------------------

bool PackMLModule::stateExistInPattern_(unsigned long stateBitPattern,
	PackMLModuleStateEnu state)
{
	if (state == ST_UNDEFINED) {
		return true;
	}
	unsigned long patternChecker = 1;
	return (stateBitPattern & (patternChecker << (state - 1)));
}

		// -------------------------------------------------------------------------

bool PackMLModule::cmdValid_(PackMLModuleStateEnu state)
{

	return stateExistInPattern_(CMD_VALID_BIT_PATTERN_LIST[stateCurrent_],
		state);
}

		// ------------------------------------------------------------------------

bool PackMLModule::isActingState(PackMLModuleStateEnu state)
{
	unsigned long actingStateBitPattern = 0xA000FAC5;

	return stateExistInPattern_(actingStateBitPattern, state);
}

		// -----------------------------------------------------------------------------


// from waiting state to acting state
void PackMLModule::executeCmd_(PackMLModuleStateEnu targetState)
{	
	stateCurrent_ = targetState;
	// reset internal bools
	resetInternalCmds_();
	resetWaitingFor_();
	resetInteruptedBy_();
}
		
		// -----------------------------------------------------------------------------
// from acting state to waiting state
void PackMLModule::executeActingState_(PackMLModuleStateEnu targetState)
{
	if (childrenInSynch_(targetState)) {
		// Update the state
		stateCurrent_ = targetState;
		// reset internal bools
		resetInternalCmds_();
		resetWaitingFor_();
	}
}

		// -----------------------------------------------------------------------------
		// Checks if the children are in the desired state in case where they want to be
		// synchronised
bool PackMLModule::childrenInSynch_(PackMLModuleStateEnu targetState)
{
			
	for (unsigned long i = 0; i < childCount_; ++i) {
		if ((childLinks_[i]->getCurrentState() != targetState) && childLinks_[i]->needParentSynch(stateCurrent_)) {
			return false;
		}
	}
	return true;
}


		// -----------------------------------------------------------------------------

void PackMLModule::resetInternalCmds_()
{
	if(isActingState(stateCurrent_)){
		externalAbort_ = false;
		externalClear_ = false;
		externalStop_ = false;
		externalReset_ = false;
		externalStart_ = false;
		externalHold_ = false;
		externalUnhold_ = false;
		externalSuspend_ = false;
		externalUnsuspend_ = false;
		externalComplete_ = false;
		externalStateComplete_ = false;
	}
	
	activate_ = false;
	deactivate_ = false;
	
	abort_ = externalAbort_;
	clear_ = externalClear_;
	stop_ = externalStop_;
	reset_ = externalReset_;
	start_ = externalStart_;
	hold_ = externalHold_;
	unhold_ = externalUnhold_;
	suspend_ = externalSuspend_;
	unsuspend_ = externalUnsuspend_;
	complete_ = externalComplete_;
	stateComplete_ = false;
			
	oldAbort_ = false;
	oldClear_ = false;
	oldStop_ = false;
	oldReset_ = false;
	oldStart_ = false;
	oldHold_ = false;
	oldUnhold_ = false;
	oldSuspend_ = false;
	oldUnsuspend_ = false;
	oldComplete_ = false;
	oldStateComplete_ = false;
	
	timeInState_ = 0.0;
}

		// -----------------------------------------------------------------------------

void PackMLModule::escalateCmdAbort()
{
	if (escalateAbort_) { 
		return pParentLink_->escalateCmdAbort();
	}
	abort_ = !overrideAbort_;
	externalAbort_ = abort_;
}
void PackMLModule::escalateCmdClear()
{
	if (escalateClear_) { 
		return pParentLink_->escalateCmdClear();
	}
	clear_ = !overrideClear_;
	externalClear_ = clear_;
}
void PackMLModule::escalateCmdStop()
{
	if (escalateStop_) { 
		return pParentLink_->escalateCmdStop();
	}
	stop_ = !overrideStop_;
	externalStop_ = stop_;
}
void PackMLModule::escalateCmdReset()
{
	if (escalateReset_) { 
		return pParentLink_->escalateCmdReset();
	}
	reset_ = !overrideReset_;
	externalReset_ = reset_;
}
void PackMLModule::escalateCmdHold()
{
	if (escalateHold_) { 
		return pParentLink_->escalateCmdHold();
	}
	hold_ = !overrideHold_;
	externalHold_ = hold_;
}
void PackMLModule::escalateCmdUnhold()
{
	if (escalateUnhold_) { 
		return pParentLink_->escalateCmdUnhold();
	}
	unhold_ = !overrideUnhold_;
	externalUnhold_ = unhold_;
}		
void PackMLModule::escalateCmdSuspend()
{
	if (escalateSuspend_) { 
		return pParentLink_->escalateCmdSuspend();
	}
	suspend_ = !overrideSuspend_;
	externalSuspend_ = suspend_;
}		
void PackMLModule::escalateCmdUnsuspend()
{
	if (escalateUnsuspend_) { 
		return pParentLink_->escalateCmdUnsuspend();
	}
	unsuspend_ = !overrideUnsuspend_;
	externalUnsuspend_ = unsuspend_;
}
void PackMLModule::escalateCmdStart()
{
	if (escalateStart_) { 
		return pParentLink_->escalateCmdStart();
	}
	start_ = !overrideStart_;
	externalStart_ = start_;
}		
void PackMLModule::escalateCmdComplete()
{
	if (escalateComplete_) { 
		return pParentLink_->escalateCmdComplete();
	}
	complete_ = !overrideComplete_;
	externalComplete_ = complete_;
}


// ----------------------------------------------------------------------------

void PackMLModule::propagateCmdAbort(bool root)
{
	abort_ = reactToAbort_ && !root;
	externalAbort_ = abort_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdAbort(false);
	}
}
void PackMLModule::propagateCmdClear(bool root)
{
	clear_ = reactToClear_ && !root;
	externalClear_ = clear_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdClear(false);
	}
}
void PackMLModule::propagateCmdStop(bool root)
{
	stop_ = reactToStop_ && !root;
	externalStop_ = stop_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdStop(false);
	}
}
void PackMLModule::propagateCmdReset(bool root)
{
	reset_ = reactToReset_ && !root;
	externalReset_ = reset_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdReset(false);
	}
}
void PackMLModule::propagateCmdHold(bool root)
{
	hold_ = reactToHold_ && !root;
	externalHold_ = hold_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdHold(false);
	}
}
void PackMLModule::propagateCmdUnhold(bool root)
{
	unhold_ = reactToUnhold_ && !root;
	externalUnhold_ = unhold_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdUnhold(false);
	}
}
void PackMLModule::propagateCmdSuspend(bool root)
{
	suspend_ = reactToSuspend_ && !root;
	externalSuspend_ = suspend_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdSuspend(false);
	}
}
void PackMLModule::propagateCmdUnsuspend(bool root)
{
	unsuspend_ = reactToUnsuspend_ && !root;
	externalUnsuspend_ = unsuspend_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdUnsuspend(false);
	}
}
void PackMLModule::propagateCmdStart(bool root)
{
	start_ = reactToStart_ && !root;
	externalStart_ = start_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdStart(false);
	}
}
void PackMLModule::propagateCmdComplete(bool root)
{
	complete_ = reactToComplete_ && !root;
	externalComplete_ = complete_;
	
	for (unsigned short i = 0; i < childCount_; ++i) {
		childLinks_[i]->propagateCmdComplete(false);
	}
}


// ----------------------------------------------------------------------------
		
bool PackMLModule::evaluateCmdAbort(bool& newCmd)
{
	if (newCmd && !oldAbort_) {
		oldAbort_ = true;
		return setCmd_(ST_ABORTING);
	}
	else if (!newCmd && oldAbort_) {
		oldAbort_ = false;
		resetCmd_(ST_ABORTING);
	}
	return true;
}
bool PackMLModule::evaluateCmdStop(bool& newCmd)
{
	if (newCmd && !oldStop_) {
		oldStop_ = true;
		return setCmd_(ST_STOPPING);
	}
	else if (!newCmd && oldStop_) {
		oldStop_ = false;
		resetCmd_(ST_STOPPING);
	}
	return true;
}
bool PackMLModule::evaluateCmdClear(bool& newCmd)
{
	if (newCmd && !oldClear_) {
		oldClear_ = true;
		return setCmd_(ST_CLEARING);
	}
	else if (!newCmd && oldClear_) {
		oldClear_ = false;
		resetCmd_(ST_CLEARING);
	}
	return true;
}
bool PackMLModule::evaluateCmdReset(bool& newCmd)
{
	if (newCmd && !oldReset_) {
		oldReset_ = true;
		return setCmd_(ST_RESETTING);
	}
	else if (!newCmd && oldReset_) {
		oldReset_ = false;
		resetCmd_(ST_RESETTING);
	}
	return true;
}
bool PackMLModule::evaluateCmdStart(bool& newCmd)
{
	if (newCmd && !oldStart_) {
		oldStart_ = true;
		return setCmd_(ST_STARTING);
	}
	else if (!newCmd && oldStart_) {
		oldStart_ = false;
		resetCmd_(ST_STARTING);
	}
	return true;
}
bool PackMLModule::evaluateCmdSuspend(bool& newCmd)
{
	if (newCmd && !oldSuspend_) {
		oldSuspend_ = true;
		return setCmd_(ST_SUSPENDING);
	}
	else if (!newCmd && oldSuspend_) {
		oldSuspend_ = false;
		resetCmd_(ST_SUSPENDING);
	}
	return true;
}
bool PackMLModule::evaluateCmdUnsuspend(bool& newCmd)
{
	if (newCmd && !oldUnsuspend_) {
		oldUnsuspend_ = true;
		return setCmd_(ST_UNSUSPENDING);
	}
	else if (!newCmd && oldUnsuspend_) {
		oldUnsuspend_ = false;
		resetCmd_(ST_UNSUSPENDING);
	}
	return true;
}
bool PackMLModule::evaluateCmdHold(bool& newCmd)
{
	if (newCmd && !oldHold_) {
		oldHold_ = true;
		return setCmd_(ST_HOLDING);
	}
	else if (!newCmd && oldHold_) {
		oldHold_ = false;
		resetCmd_(ST_HOLDING);
	}
	return true;
}
bool PackMLModule::evaluateCmdUnhold(bool& newCmd)
{
	if (newCmd && !oldUnhold_) {
		oldUnhold_ = true;
		return setCmd_(ST_UNHOLDING);
	}
	else if (!newCmd && oldUnhold_) {
		oldUnhold_ = false;
		resetCmd_(ST_UNHOLDING);
	}
	return true;
}
bool PackMLModule::evaluateCmdComplete(bool& newCmd)
{
	if (newCmd && !oldComplete_) {
		oldComplete_ = true;
		return setCmd_(ST_COMPLETING);
	}
	else if (!newCmd && oldComplete_) {
		oldComplete_ = false;
		resetCmd_(ST_COMPLETING);
	}
	return true;
}
bool PackMLModule::evaluateCmdStateComplete(bool& newCmd)
{
	if (newCmd && !oldStateComplete_) {
		oldStateComplete_ = true;
		return setCmd_(ST_UNDEFINED);
	}
	else if (!newCmd && oldStateComplete_) {
		oldStateComplete_ = false;
		resetCmd_(ST_UNDEFINED);
	}
	return true;
}

bool PackMLModule::setCmdAbort(){
	return setCmd_(ST_ABORTING);
}
bool PackMLModule::setCmdStop(){
	return setCmd_(ST_STOPPING);
}
bool PackMLModule::setCmdClear(){
	return setCmd_(ST_CLEARING);
}
bool PackMLModule::setCmdReset(){
	return setCmd_(ST_RESETTING);
}
bool PackMLModule::setCmdStart(){
	return setCmd_(ST_STARTING);
}
bool PackMLModule::setCmdSuspend(){
	return setCmd_(ST_SUSPENDING);
}
bool PackMLModule::setCmdUnsuspend(){
	return setCmd_(ST_UNSUSPENDING);
}
bool PackMLModule::setCmdHold(){
	return setCmd_(ST_HOLDING);
}
bool PackMLModule::setCmdUnhold(){
	return setCmd_(ST_UNHOLDING);
}
bool PackMLModule::setCmdComplete(){
	return setCmd_(ST_COMPLETING);
}
bool PackMLModule::setCmdStateComplete(){
	return setCmd_(ST_UNDEFINED);
}


void PackMLModule::resetCmdAbort(){
	return resetCmd_(ST_ABORTING);
}
void PackMLModule::resetCmdStop(){
	return resetCmd_(ST_STOPPING);
}
void PackMLModule::resetCmdClear(){
	return resetCmd_(ST_CLEARING);
}
void PackMLModule::resetCmdReset(){
	return resetCmd_(ST_RESETTING);
}
void PackMLModule::resetCmdStart(){
	return resetCmd_(ST_STARTING);
}
void PackMLModule::resetCmdSuspend(){
	return resetCmd_(ST_SUSPENDING);
}
void PackMLModule::resetCmdUnsuspend(){
	return resetCmd_(ST_UNSUSPENDING);
}
void PackMLModule::resetCmdHold(){
	return resetCmd_(ST_HOLDING);
}
void PackMLModule::resetCmdUnhold(){
	return resetCmd_(ST_UNHOLDING);
}
void PackMLModule::resetCmdComplete(){
	return resetCmd_(ST_COMPLETING);
}
void PackMLModule::resetCmdStateComplete(){
	return resetCmd_(ST_UNDEFINED);
}

		
		// -----------------------------------------------------------------------------
		
bool PackMLModule::setCmd_(PackMLModuleStateEnu targetActingState) // NOLINT
{

	bool cmdValid = cmdValid_(targetActingState);

	switch (targetActingState) { // NOCCM
		case ST_CLEARING:
			if (overrideClear_ && !escalateClear_) {
				return false; // error code
			}
			if (hasParent_ && escalateClear_ && cmdValid) {
				pParentLink_->escalateCmdClear();
				setInteruptedBy_();
			}
			clear_ = !overrideClear_; //!overrideAbort_ || !escalateAbort_;
			break;

		case ST_STARTING:
			if (overrideStart_ && !escalateStart_) {
				return false; // error code
			}
			if (hasParent_ && escalateStart_ && cmdValid) {
				pParentLink_->escalateCmdStart();
				setInteruptedBy_();
			}
			start_ = !overrideStart_;
			break;

		case ST_STOPPING:
			if (overrideStop_ && !escalateStop_) {
				return false; // error code
			}
			if (hasParent_ && escalateStop_) {
				pParentLink_->escalateCmdStop();
			}
			if(cmdValid){
				setInteruptedBy_();
				stop_ = !overrideStop_;
			}
			break;

		case ST_ABORTING:
			if (overrideAbort_ && !escalateAbort_) {
				return false; // error code
			}
			if (hasParent_ && escalateAbort_) {
				pParentLink_->escalateCmdAbort();
			}
			
			if(cmdValid){
				setInteruptedBy_();
				abort_ = !overrideAbort_;
			}
			break;

		case ST_HOLDING:
			if (overrideHold_ && !escalateHold_) {
				return false; // error code
			}
			if (hasParent_ && escalateHold_) {
				pParentLink_->escalateCmdHold();
			}
			if(cmdValid){
				setInteruptedBy_();
				hold_ = !overrideHold_;
			}
			break;

		case ST_UNHOLDING:
			if (overrideUnhold_ && !escalateUnhold_) {
				return false; // error code
			}
			if (hasParent_ && escalateUnhold_ && cmdValid) {
				pParentLink_->escalateCmdUnhold();
				setInteruptedBy_();
			}
			unhold_ = !overrideUnhold_;
			break;

		case ST_SUSPENDING:
			if (overrideSuspend_ && !escalateSuspend_) {
				return false; // error code
			}
			if (hasParent_ && escalateSuspend_) {
				pParentLink_->escalateCmdSuspend();
			}
			if(cmdValid){
				setInteruptedBy_();
				suspend_ = !overrideSuspend_;
			}
			break;

		case ST_UNSUSPENDING:
			if (overrideUnsuspend_ && !escalateUnsuspend_) {
				return false; // error code
			}
			if (hasParent_ && escalateUnsuspend_ && cmdValid) {
				pParentLink_->escalateCmdUnsuspend();
				setInteruptedBy_();
			}
			unsuspend_ = !overrideUnsuspend_;
			break;

		case ST_RESETTING:
			if (overrideReset_ && !escalateReset_) {
				return false; // error code
			}
			if (hasParent_ && escalateReset_ && cmdValid) {
				pParentLink_->escalateCmdReset();
				setInteruptedBy_();
			}
			reset_ = !overrideReset_;
			break;

		case ST_COMPLETING:
			// check if the state group is configured
			if (overrideComplete_ && !escalateComplete_) {
				return false; // error code
			}
			if (hasParent_ && escalateComplete_) {
				pParentLink_->escalateCmdComplete();
			}
			if(cmdValid){
				setInteruptedBy_();
				complete_ = !overrideComplete_;
			}
			break;

		case ST_UNDEFINED:
			stateComplete_ = true;
			break;

		default:
			break;
	}

	return true;
}

		// -----------------------------------------------------------------------------

void PackMLModule::resetCmd_(PackMLModuleStateEnu targetActingState)
{

	switch (targetActingState) { // NOCCM
		case ST_CLEARING:
			clear_ = externalClear_;
			break;

		case ST_STARTING:
			start_ = externalStart_;
			break;

		case ST_STOPPING:
			stop_ = externalStop_;
			break;

		case ST_ABORTING:
			abort_ = externalAbort_;
			break;

		case ST_HOLDING:
			hold_ = externalHold_;
			break;

		case ST_UNHOLDING:
			unhold_ = externalUnhold_;
			break;

		case ST_SUSPENDING:
			suspend_ = externalSuspend_;
			break;

		case ST_UNSUSPENDING:
			unsuspend_ = externalUnsuspend_;
			break;

		case ST_RESETTING:
			reset_ = externalReset_;
			break;

		case ST_COMPLETING:
			complete_ = externalComplete_;
			break;

		case ST_UNDEFINED:
			stateComplete_ = externalStateComplete_;
			break;

		default:
			break;
	}
}

		

		// -----------------------------------------------------------------------------
		
		// if parent synchronisation needed
bool PackMLModule::needParentSynch(PackMLModuleStateEnu state)
{
	if (hierarchyLevel_ == 0) {
		return true;
	}

	switch (stateCurrent_) { // NOCCM

		case ST_CLEARING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_CLEARING:
					return overrideClear_ || reactToClear_;
				default:
					break;
			}
			break;
		
		case ST_STOPPED:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_RESETTING:
					return overrideReset_ || reactToReset_;
				default:
					break;
			}
			break;

		case ST_IDLE:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_STARTING:
					return overrideStart_ || reactToStart_;
				default:
					break;
			}
			break;

		case ST_SUSPENDED:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_UNSUSPENDING:
					return overrideUnsuspend_ || reactToUnsuspend_;
				case ST_HOLDING:
					return overrideHold_ || reactToHold_;
				case ST_COMPLETING:
					return overrideComplete_ || reactToComplete_;
				default:
					break;
			}
			break;

		case ST_EXECUTE:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_SUSPENDING:
					return overrideSuspend_ || reactToSuspend_;
				case ST_HOLDING:
					return overrideHold_ || reactToHold_;
				case ST_COMPLETING:
					return overrideComplete_ || reactToComplete_;
				default:
					break;
			}
			break;

		case ST_STOPPING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				default:
					break;
			}
			break;

		case ST_ABORTING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				default:
					break;
			}
			break;

		case ST_ABORTED:
			switch (state) { // NOCCM
				case ST_CLEARING:
					return overrideClear_ || reactToClear_;
				default:
					break;
			}
			break;

		case ST_HELD:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_UNHOLDING:
					return overrideUnhold_ || reactToUnhold_;
				case ST_COMPLETING:
					return overrideComplete_ || reactToComplete_;
				default:
					break;
			}
			break;
		
		case ST_SUSPENDING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_SUSPENDING:
					return overrideSuspend_ || reactToSuspend_;
				default:
					break;
			}
			break;
		case ST_UNSUSPENDING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_UNSUSPENDING:
					return overrideUnsuspend_ || reactToUnsuspend_;
				default:
					break;
			}
			break;
		case ST_COMPLETING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_COMPLETING:
					return overrideComplete_ || reactToComplete_;
				default:
					break;
			}
			break;
		case ST_STARTING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_STARTING:
					return overrideStart_ || reactToStart_;
				default:
					break;
			}
			break;
		case ST_HOLDING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_HOLDING:
					return overrideHold_ || reactToHold_;
				default:
					break;
			}
			break;
		case ST_UNHOLDING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_UNHOLDING:
					return overrideUnhold_ || reactToUnhold_;
				default:
					break;
			}
			break;

		case ST_RESETTING:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_RESETTING:
					return overrideReset_ || reactToReset_;
				default:
					break;
			}
			break;
		
		case ST_COMPLETE:
			switch (state) { // NOCCM
				case ST_ABORTING:
					return overrideAbort_ || reactToAbort_;
				case ST_STOPPING:
					return overrideStop_ || reactToStop_;
				case ST_RESETTING:
					return overrideReset_ || reactToReset_;
				default:
					break;
			}
			break;

		default:
			break;
	}

	return false;
}

// -----------------------------------------------------------------------------
// decide if reacto to only should when parent + 1 state in front of child. e.g. instead of ST_ABORTING and ST_ABORTED --> only ST_ABORTING
void PackMLModule::checkParentStateCondition_()
{
	if (hierarchyLevel_ == 0) {
		return;
	}

	PackMLModuleStateEnu parentState = getParentCurrentState();

	if (parentState == stateCurrent_) {
		return;
	}
		
	switch (stateCurrent_) { // NOCCM
		case ST_CLEARING:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				default:
					break;
			}
			break;

		case ST_STOPPED:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;

				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
					deactivate_ = (activationCondition_ == 1);
					break;
				
				case ST_RESETTING:
					reset_ = overrideReset_ || reset_ || reactToReset_;
					break;
				
				case ST_IDLE:
				case ST_STARTING:
				case ST_SUSPENDED:
				case ST_EXECUTE:
				case ST_HOLDING:
				case ST_HELD:
				case ST_UNHOLDING:
				case ST_SUSPENDING:
				case ST_UNSUSPENDING:
				case ST_COMPLETING:
				case ST_COMPLETE:
					reset_ = overrideReset_ || reset_;
					break;

				default:
					break;
			}
			break;

		case ST_IDLE:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				
				case ST_CLEARING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_STOPPING:
					stop_ = overrideStop_ || stop_ || reactToStop_;
					break;
				case ST_STOPPED:
					stop_ = overrideStop_ || stop_;
					break;

				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
				case ST_ACTIVATING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;
			
				case ST_STARTING:
					start_ = overrideStart_ || start_ || reactToStart_;
					break;
				
				case ST_EXECUTE:
				case ST_SUSPENDED:
				case ST_HOLDING:
				case ST_HELD:
				case ST_UNHOLDING:
				case ST_SUSPENDING:
				case ST_UNSUSPENDING:
				case ST_COMPLETING:
				case ST_COMPLETE:
					start_ = overrideStart_ || start_;
					break;

				default:
					break;
			}
			break;

		case ST_SUSPENDED:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				
				case ST_CLEARING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_STOPPING:
					stop_ = overrideStop_ || stop_ || reactToStop_;
					break;
				case ST_STOPPED:
					stop_ = overrideStop_ || stop_;
					break;
				
				case ST_UNSUSPENDING:
					unsuspend_ = overrideUnsuspend_ || unsuspend_ || reactToUnsuspend_;
					break;

				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
				case ST_ACTIVATING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_RESETTING:
				case ST_IDLE: // **********************
					unsuspend_ = overrideUnsuspend_ || unsuspend_;
					stop_ = (overrideStop_ || stop_) && !unsuspend_;
					break;
				
				case ST_COMPLETING:
					complete_ = overrideComplete_ || complete_ || reactToComplete_;
					break;
				case ST_COMPLETE:
					complete_ = overrideComplete_ || complete_;
					break;
				
				case ST_HOLDING:
					hold_ = overrideHold_ || hold_ || reactToHold_;
					break;
				case ST_HELD:
					hold_ = overrideHold_ || hold_;
					break;

				case ST_EXECUTE:
				case ST_STARTING:
				case ST_UNHOLDING:
					unsuspend_ = overrideUnsuspend_ || unsuspend_;
					break;

				default:
					break;
			}
			break;

		case ST_EXECUTE:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				
				case ST_CLEARING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_STOPPING:
					stop_ = overrideStop_ || stop_ || reactToStop_;
					break;
				
				case ST_STOPPED:
					stop_ = overrideStop_ || stop_;
					break;
	
				case ST_SUSPENDING:
					suspend_ = overrideSuspend_ || suspend_ || reactToSuspend_;
					break;
				
				case ST_SUSPENDED:
					suspend_ = overrideSuspend_ || suspend_;
					break;

				case ST_HOLDING:
					hold_ = overrideHold_ || hold_ || reactToHold_;
					break;
				
				case ST_HELD:
					hold_ = overrideHold_ || hold_;
					break;

				case ST_COMPLETING:
					complete_ = overrideComplete_ || complete_ || reactToComplete_;
					break;
				
				case ST_COMPLETE:
					complete_ = overrideComplete_ || complete_;
					break;

				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
				case ST_ACTIVATING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_RESETTING:
				case ST_IDLE:
					complete_ = overrideComplete_ || complete_;
					stop_ = (overrideStop_ || stop_) && !complete_;
					break;

				default:
					break;
			}
			break;

		case ST_STOPPING:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				default:
					break;
			}
			break;

		case ST_ABORTED:
			switch (parentState) { // NOCCM
				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
					deactivate_ = (activationCondition_ == 1);
					break;
				
				case ST_CLEARING:
					clear_ = overrideClear_ || clear_ || reactToClear_;
					break;

				case ST_STOPPED:
				case ST_STARTING:
				case ST_IDLE:
				case ST_SUSPENDED:
				case ST_EXECUTE:
				case ST_STOPPING:
				case ST_HOLDING:
				case ST_HELD:
				case ST_UNHOLDING:
				case ST_SUSPENDING:
				case ST_UNSUSPENDING:
				case ST_RESETTING:
				case ST_COMPLETING:
				case ST_COMPLETE:
				case ST_ACTIVATING:
					clear_ = overrideClear_ || clear_;
					break;

				default:
					break;
			}
			break;

		case ST_HELD:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				
				case ST_CLEARING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_STOPPING:
					stop_ = overrideStop_ || stop_ || reactToStop_;
					break;
				
				case ST_STOPPED:
					stop_ = overrideStop_ || stop_;
					break;
				
				case ST_UNHOLDING:
					unhold_ = overrideUnhold_ || unhold_ || reactToUnhold_;
					break;

				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
				case ST_ACTIVATING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_RESETTING:
				case ST_IDLE: // **********************
					unhold_ = overrideUnhold_ || unhold_;
					stop_ = (overrideStop_ || stop_) && !unhold_;
					break;
				
				case ST_COMPLETING:
					complete_ = overrideComplete_ || complete_ || reactToComplete_;
					break;
				case ST_COMPLETE:
					complete_ = overrideComplete_ || complete_;
					break;
				
				case ST_EXECUTE:
				case ST_SUSPENDING:
				case ST_SUSPENDED:
				case ST_UNSUSPENDING:
				case ST_STARTING:
					unhold_ = overrideUnhold_ || unhold_;
					break;

				default:
					break;
			}
			break;

		case ST_STARTING:
		case ST_HOLDING:
		case ST_UNHOLDING:
		case ST_SUSPENDING:
		case ST_UNSUSPENDING:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				
				case ST_CLEARING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_STOPPING:
					stop_ = overrideStop_ || stop_ || reactToStop_;
					break;
				
				case ST_STOPPED:
					stop_ = overrideStop_ || stop_;
					break;

				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
				case ST_ACTIVATING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_RESETTING:
				case ST_IDLE:
					stop_ = overrideStop_ || stop_;
					break;

				default:
					break;
			}
			break;

		case ST_RESETTING:
		case ST_COMPLETING:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				
				case ST_CLEARING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_STOPPING:
					stop_ = overrideStop_ || stop_ || reactToStop_;
					break;
				
				case ST_STOPPED:
					stop_ = overrideStop_ || stop_;
					break;
				
				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
				case ST_ACTIVATING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				default:
					break;
			}
			break;

		case ST_COMPLETE:
			switch (parentState) { // NOCCM
				case ST_ABORTING:
					abort_ = overrideAbort_ || abort_ || reactToAbort_;
					break;
				case ST_ABORTED:
					abort_ = overrideAbort_ || abort_;
					break;
				
				case ST_CLEARING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_STOPPING:
					stop_ = overrideStop_ || stop_ || reactToStop_;
					break;
				
				case ST_STOPPED:
					stop_ = overrideStop_ || stop_;
					break;
				
				case ST_DEACTIVATING:
				case ST_DEACTIVATED:
				case ST_ACTIVATING:
					stop_ = overrideStop_ || stop_;
					abort_ = (overrideAbort_ || abort_) && !stop_;
					break;

				case ST_RESETTING:
					reset_ = overrideReset_ || reset_ || reactToReset_;
					break;
				
				case ST_IDLE:
				case ST_STARTING:
				case ST_SUSPENDED:
				case ST_EXECUTE:
				case ST_HOLDING:
				case ST_HELD:
				case ST_UNHOLDING:
				case ST_SUSPENDING:
				case ST_UNSUSPENDING:
					reset_ = overrideReset_ || reset_;
					break;

				default:
					break;
			}
			break;

		case ST_DEACTIVATED:
			if (parentState != ST_DEACTIVATING) {
				activate_ = (activationCondition_ == 1);
			}
			break;

		default:
			break;
	}
	
}



void PackMLModule::resetWaitingFor_()
{
		if(pWaitingFor_ == nullptr)
			return;
		
	pWaitingFor_->resetValues(moduleId_);
}


void PackMLModule::setWaitingFor_()
{
		if(pWaitingFor_ == nullptr)
			return;
		
	pWaitingFor_->setValues(moduleName_.c_str(), modeCurrent_, stateCurrent_, subStateCurrent_, stateComplete_, hierarchyLevel_, moduleId_, stateInfo_.c_str());

}

	//	 -----------------------------------------------------------------------------

void PackMLModule::resetInteruptedBy_()
{
	if(pInteruptedBy_ == nullptr)
		return;
		
	PackMLModuleStateEnu state = pInteruptedBy_->getStateCurrent();
	switch(state){
		case ST_EXECUTE:
			if(stateCurrent_ == ST_ABORTING || stateCurrent_ == ST_SUSPENDING || stateCurrent_ == ST_HOLDING || stateCurrent_ == ST_STOPPING || stateCurrent_ == ST_COMPLETING)
				return;
			break;
		
		case ST_STOPPED:
			if(stateCurrent_ == ST_ABORTING || stateCurrent_ == ST_RESETTING)
				return;
			break;
		
		case ST_IDLE:
			if(stateCurrent_ == ST_ABORTING || stateCurrent_ == ST_STOPPING || stateCurrent_ == ST_STARTING)
				return;
			break;
		
		case ST_HELD:
			if(stateCurrent_ == ST_ABORTING || stateCurrent_ == ST_STOPPING || stateCurrent_ == ST_UNHOLDING)
				return;
			break;
		
		case ST_SUSPENDED:
			if(stateCurrent_ == ST_ABORTING || stateCurrent_ == ST_STOPPING || stateCurrent_ == ST_UNSUSPENDING)
				return;
			break;
		
		case ST_ABORTED:
			if(stateCurrent_ == ST_CLEARING)
				return;
			break;
		
		case ST_COMPLETE:
			if(stateCurrent_ == ST_ABORTING || stateCurrent_ == ST_STOPPING || stateCurrent_ == ST_RESETTING)
				return;
			break;
		
	//	case ST_RESETTING: ST_STARTING: ST_HOLDING: ST_UNHOLDING: ST_SUSPENDING: ST_UNSUSPENDING: ST_COMPLETING: ST_STOPPING: ST_ABORTING: ST_CLEARING:
		default:
			if(stateCurrent_ == ST_ABORTING || stateCurrent_ == ST_STOPPING)
				return;
			break;
			

	}
	

	pInteruptedBy_->resetValues(moduleId_);
}

void PackMLModule::setInteruptedBy_()
{
		if(pInteruptedBy_ == nullptr)
			return;
		
	pInteruptedBy_->setValues(moduleName_.c_str(), modeCurrent_, stateCurrent_, subStateCurrent_, stateComplete_, pInteruptedBy_->getHierarchyLevel() + 1, moduleId_, stateInfo_.c_str());

}

void PackMLModule::setInteruptedBy(PackMLModule* pPackMLModule)
{
		if(pInteruptedBy_ == nullptr)
			return;
		
	pInteruptedBy_->setValues(pPackMLModule->moduleName_.c_str(), pPackMLModule->modeCurrent_, pPackMLModule->stateCurrent_, pPackMLModule->subStateCurrent_, pPackMLModule->stateComplete_, pPackMLModule->pInteruptedBy_->getHierarchyLevel() + 1, moduleId_, stateInfo_.c_str());

}

		// -----------------------------------------------------------------------------

void PackMLModule::updatePackMLModel_()
{

	switch (stateCurrent_) { // NOCCM
		case ST_UNDEFINED:
			break;

		case ST_STOPPING:
		case ST_CLEARING:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				executeActingState_(ST_STOPPED);
			}
			else if (needParentSynch(stateCurrent_)) {
				setWaitingFor_();
			}
			break;

		case ST_STOPPED:
			checkActivationCondition_();
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (reset_) {
					executeCmd_(ST_RESETTING);
				}
				else if (deactivate_) {
					executeCmd_(ST_DEACTIVATING);
				}
			}
			else if (reset_ || deactivate_) {
				setWaitingFor_();
			}
			break;

		case ST_IDLE:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else if (start_) {
					executeCmd_(ST_STARTING);
				}
			}
			else if (stop_ || start_) {
				setWaitingFor_();
			}
			break;

		case ST_SUSPENDED:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else if (complete_) {
					executeCmd_(ST_COMPLETING);
				}
				else if (hold_){
					executeCmd_(ST_HOLDING);
				}
				else if (unsuspend_){
					executeCmd_(ST_UNSUSPENDING);
				}
			}
			else if (stop_ || unsuspend_ || hold_ || complete_) {
				setWaitingFor_();
			}
			break;

		case ST_EXECUTE:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else if (complete_) {
					executeCmd_(ST_COMPLETING);
				}
				else if (hold_) {
					executeCmd_(ST_HOLDING);
				}
				else if (suspend_) {
					executeCmd_(ST_SUSPENDING);
				}
			}
			else if (stop_ || suspend_ || hold_ || complete_) {
				setWaitingFor_();
			}
			break;

		case ST_ABORTING:
			if (stateComplete_) {
				executeActingState_(ST_ABORTED);
			}
			else if (needParentSynch(stateCurrent_)) {
				setWaitingFor_();
			}
			break;

		case ST_ABORTED:
			checkActivationCondition_();
			if (stateComplete_) {
				if (clear_) {
					executeCmd_(ST_CLEARING);
				}
				else if (deactivate_) {
					executeCmd_(ST_DEACTIVATING);
				}
			}
			else if (clear_ || deactivate_) {
				setWaitingFor_();
			}
			break;

		case ST_HELD:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else if (complete_) {
					executeCmd_(ST_COMPLETING);
				}
				else if (unhold_){
					executeCmd_(ST_UNHOLDING);
				}
			}
			else if (stop_ || unhold_ || complete_) {
				setWaitingFor_();
			}
			break;
				
		case ST_STARTING:
		case ST_UNHOLDING:
		case ST_UNSUSPENDING:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else {
					executeActingState_(ST_EXECUTE);
				}
			}
			else if (needParentSynch(stateCurrent_)) {
				setWaitingFor_();
			}
			break;

		case ST_RESETTING:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else {
					executeActingState_(ST_IDLE);
				}
			}
			else if (needParentSynch(stateCurrent_)) {
				setWaitingFor_();
			}
			break;

		case ST_COMPLETING:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else {
					executeActingState_(ST_COMPLETE);
				}
			}
			else if (needParentSynch(stateCurrent_)) {
				setWaitingFor_();
			}
			break;

		case ST_HOLDING:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else {
					executeActingState_(ST_HELD);
				}
			}
			else if (needParentSynch(stateCurrent_)) {
				setWaitingFor_();
			}
			break;

		case ST_SUSPENDING:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else {
					executeActingState_(ST_SUSPENDED);
				}
			}
			else if (needParentSynch(stateCurrent_)) {
				setWaitingFor_();
			}
			break;

		case ST_COMPLETE:
			if (abort_) {
				executeCmd_(ST_ABORTING);
			}
			else if (stateComplete_) {
				if (stop_) {
					executeCmd_(ST_STOPPING);
				}
				else if (reset_) {
					executeCmd_(ST_RESETTING);
				}
			}
			else if (stop_ || reset_) {
				setWaitingFor_();
			}
			break;

		case ST_DEACTIVATING:
			if (stateComplete_) {
				executeActingState_(ST_DEACTIVATED);
			}
			else {
				setWaitingFor_();
			}
			break;

		case ST_DEACTIVATED:
			checkActivationCondition_();
			if (stateComplete_) {
				if (activate_) {
					executeCmd_(ST_ACTIVATING);
				}
			}
			else if (activate_) {
				setWaitingFor_();
			}
			break;

		case ST_ACTIVATING:
			if (stateComplete_) {
				executeActingState_(ST_STOPPED);
			}
			else {
				setWaitingFor_();
			}
			break;
	}
}

		// -----------------------------------------------------------------------------

void PackMLModule::checkActivationCondition_()
{

	switch (activationCondition_) {
		case 0:
			activate_ = true;
			break;
		case 1: // by parent: do nothing
			break;
		case 2:
			activate_ = activationPv_;;
			deactivate_ = !activate_;
			break;
	
		default:
			break;
	}
	
}

		// -----------------------------------------------------------------------------
		






