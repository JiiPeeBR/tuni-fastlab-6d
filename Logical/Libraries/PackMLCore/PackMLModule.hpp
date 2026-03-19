#ifndef __PACKMLMODULE_HPP__
#define __PACKMLMODULE_HPP__

#include "PackMLModuleEnums.hpp"
#include <vector>
#include <string>
#include <string.h>
//#include <cmath>
#include "AtomicSemaphore.hpp"
#include "PackMLModuleSharedInfo.hpp"



		// PackMLModule main class
class PackMLModule {
	
	public:
	PackMLModule(const char* pModuleName);
	~PackMLModule();
		
	// *** onCreated() ***
	// root module
	void initModule();
	// child module
	bool initModule(PackMLModule* pParent);

	// *** onBeforeShutdown() ***
	bool exitModule();
			
	// *** run() ***
	void runPackMLModule();
			

	// **********************************************************
	// ************* Real time parameter update *****************
	// **********************************************************
	void setActivationCondition(short int newParameter){
		activationCondition_ = newParameter;
	}
	
			
	void setOverrideAbort(bool newParameter)
	{
		overrideAbort_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideStop(bool newParameter)
	{
		overrideStop_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideClear(bool newParameter)
	{
		overrideClear_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideReset(bool newParameter)
	{
		overrideReset_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideStart(bool newParameter)
	{
		overrideStart_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideSuspend(bool newParameter)
	{
		overrideSuspend_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideUnsuspend(bool newParameter)
	{
		overrideUnsuspend_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideHold(bool newParameter)
	{
		overrideHold_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideUnhold(bool newParameter)
	{
		overrideUnhold_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setOverrideComplete(bool newParameter)
	{
		overrideComplete_ = newParameter && (hierarchyLevel_ > 0);
	}
			
			
	void setReactToAbort(bool newParameter)
	{
		reactToAbort_ = newParameter && (hierarchyLevel_ > 0);
	}		
	void setReactToStop(bool newParameter)
	{
		reactToStop_ = newParameter && (hierarchyLevel_ > 0);
	}		
	void setReactToClear(bool newParameter)
	{
		reactToClear_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setReactToReset(bool newParameter)
	{
		reactToReset_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setReactToStart(bool newParameter)
	{
		reactToStart_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setReactToSuspend(bool newParameter)
	{
		reactToSuspend_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setReactToUnsuspend(bool newParameter)
	{
		reactToUnsuspend_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setReactToHold(bool newParameter)
	{
		reactToHold_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setReactToUnhold(bool newParameter)
	{
		reactToUnhold_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setReactToComplete(bool newParameter)
	{
		reactToComplete_ = newParameter && (hierarchyLevel_ > 0);
	}
				
	
	void setEscalateAbort(bool newParameter)
	{
		escalateAbort_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateStop(bool newParameter)
	{
		escalateStop_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateClear(bool newParameter)
	{
		escalateClear_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateReset(bool newParameter)
	{
		escalateReset_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateStart(bool newParameter)
	{
		escalateStart_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateSuspend(bool newParameter)
	{
		escalateSuspend_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateUnsuspend(bool newParameter)
	{
		escalateUnsuspend_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateHold(bool newParameter)
	{
		escalateHold_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateUnhold(bool newParameter)
	{
		escalateUnhold_ = newParameter && (hierarchyLevel_ > 0);
	}
	void setEscalateComplete(bool newParameter)
	{
		escalateComplete_ = newParameter && (hierarchyLevel_ > 0);
	}
			
	bool evaluateCmdAbort(bool& newCmd);
	bool evaluateCmdStop(bool& newCmd);
	bool evaluateCmdClear(bool& newCmd);
	bool evaluateCmdReset(bool& newCmd);
	bool evaluateCmdStart(bool& newCmd);
	bool evaluateCmdSuspend(bool& newCmd);
	bool evaluateCmdUnsuspend(bool& newCmd);
	bool evaluateCmdHold(bool& newCmd);
	bool evaluateCmdUnhold(bool& newCmd);
	bool evaluateCmdComplete(bool& newCmd);
	bool evaluateCmdStateComplete(bool& newCmd);
	
	bool setCmdAbort();
	bool setCmdStop();
	bool setCmdClear();
	bool setCmdReset();
	bool setCmdStart();
	bool setCmdSuspend();
	bool setCmdUnsuspend();
	bool setCmdHold();
	bool setCmdUnhold();
	bool setCmdComplete();
	bool setCmdStateComplete();
	
	bool getCmdAbort(){
		return abort_;
	}
	bool getCmdStop(){
		return stop_;
	}
	bool getCmdClear(){
		return clear_;
	}
	bool getCmdReset(){
		return reset_;
	}
	bool getCmdStart(){
		return start_;
	}
	bool getCmdSuspend(){
		return suspend_;
	}
	bool getCmdUnsuspend(){
		return unsuspend_;
	}
	bool getCmdHold(){
		return hold_;
	}
	bool getCmdUnhold(){
		return unhold_;
	}
	bool getCmdComplete(){
		return complete_;
	}
	bool getCmdStateComplete(){
		return stateComplete_;
	}
	
	void resetCmdAbort();
	void resetCmdStop();
	void resetCmdClear();
	void resetCmdReset();
	void resetCmdStart();
	void resetCmdSuspend();
	void resetCmdUnsuspend();
	void resetCmdHold();
	void resetCmdUnhold();
	void resetCmdComplete();
	void resetCmdStateComplete();

	// **********************************************************

	PackMLModuleStateEnu getParentCurrentState();

	long int getParentCurrentSubState();

	const char *getParentName();
	
	bool getParentStateComplete();
	
	PackMLModule* getParentAdr() { return pParentLink_; }	
	
	bool getSiblingsStateComplete();
	
	bool getChildrenStateComplete();	

	const char *getCurrentStateStr() const;
	
	const char *getStateStr(PackMLModuleStateEnu state) const;

	const char *getCurrentModeStr() const;

	unsigned long getChildCount() { return childCount_; }
	
	unsigned long getSiblingCount();
			
	unsigned short getHierarchyLevel()
	{
		return hierarchyLevel_;
	}

	// ************************* Service interface methods *********************
	// Name of the module
	const char* getModuleName() { return moduleName_.c_str(); }
	unsigned long int getModuleId() { return moduleId_; }

	// Called by the IEC function
	const char* getStateInfo() { return stateInfo_.c_str(); }
	
	bool setCurrentMode(long int mode);
	long int getCurrentMode(){ return modeCurrent_; }
	const char* getCurrentModeName() const;
	const char* getModeName(signed long int modeId) const;
	bool isModeChangePossible();

	bool getModuleReady() { return moduleReady_; }
	void setModuleReady(bool value);

	void setNewModeCurrent(long int mode);
	void setHierarchyLevel(unsigned short level);
	void setAllStateComplete();

	bool registerChild(PackMLModule* pChild); // called during onCreated()
	bool unregisterChild(PackMLModule* pChild);

	void escalateCmdAbort();
	void escalateCmdClear();
	
	void escalateCmdSuspend();
	void escalateCmdUnsuspend();

	void escalateCmdHold();
	void escalateCmdUnhold();
	
	void escalateCmdStop();
	void escalateCmdReset();
	
	void escalateCmdStart();
	void escalateCmdComplete();
	
	void propagateCmdAbort(bool root);
	void propagateCmdClear(bool root);
	
	void propagateCmdSuspend(bool root);
	void propagateCmdUnsuspend(bool root);

	void propagateCmdHold(bool root);
	void propagateCmdUnhold(bool root);
	
	void propagateCmdStop(bool root);
	void propagateCmdReset(bool root);
	
	void propagateCmdStart(bool root);
	void propagateCmdComplete(bool root);

	PackMLModuleStateEnu getCurrentState(){
		return stateCurrent_;
	}
	
	void setCurrentSubState(long int subState){
		subStateCurrent_ = subState;
		timeInSubState_ = 0.0;
	}
			
	long int getCurrentSubState(){
		return subStateCurrent_;
	}
		
	bool getStateComplete(){
		return stateComplete_;
	}
	// check if child wants to be synchronised
	bool needParentSynch(PackMLModuleStateEnu parentState);
	
	void setSharedInfoPtrs(PackMLModuleSharedInfo* pWaitingFor, PackMLModuleSharedInfo* pInteruptedBy);
	
	void setActivationPv(bool activationPv) { activationPv_ = activationPv; }
	
	PackMLModuleSharedInfo* getWaitingForPtr() { 
		return pWaitingFor_; 
	}

	PackMLModuleSharedInfo* getInteruptedByPtr() { 
		return pInteruptedBy_; 
	}
	
	PackMLModuleStateEnu getChildCurrentState(unsigned long int childIndex);
	long int getChildCurrentSubState(unsigned long int childIndex);
	bool getChildStateComplete(unsigned long int childIndex);
	const char* getChildName(unsigned long int childIndex);
	
	PackMLModuleStateEnu getSiblingCurrentState(unsigned long int siblingIndex);
	long int getSiblingCurrentSubState(unsigned long int siblingIndex);
	bool getSiblingStateComplete(unsigned long int siblingIndex);
	const char* getSiblingName(unsigned long int siblingIndex);
	
	float getTimeInState() { return timeInState_; }
	float getTimeInSubState() { return timeInSubState_; }
	
	void setCycleTime(float cycleTime) { cycleTime_ = cycleTime; }
	
	PackMLModule* getParentPtr();
	PackMLModule* getChildPtr(unsigned long int childIdx);
	PackMLModule* getSiblingPtr(unsigned long int siblingIdx);
	
	void* createUserMemory(unsigned long int userMemorySize);
	void* getUserMemoryPtr();
	void deleteUserMemory();
	
	bool isActingState(PackMLModuleStateEnu state);
	bool isWaitingState(PackMLModuleStateEnu state){
		return !isActingState(state);
	}
	
	void setInteruptedBy(PackMLModule* pPackMLModule);
	
	void setStateInfo(std::string stateInfo){
		stateInfo_ = stateInfo;
	}
	
	private:
    

	// --------------------------------------------------------
	// **************** Will be private ***********************
	// --------------------------------------------------------

	// unique service name identifier
	std::string moduleName_;
	unsigned long moduleId_;
	unsigned long generateId_(const char *pName);


	// used during the registration
	AtomicSemaphore semaphore_;

	// **************** FB parameters placeholder ******************
	std::string stateInfo_;

	short int activationCondition_;
	
	bool overrideAbort_;
	bool overrideStop_;
	bool overrideClear_;
	bool overrideReset_;
	bool overrideStart_;
	bool overrideSuspend_;
	bool overrideUnsuspend_;
	bool overrideHold_;
	bool overrideUnhold_;
	bool overrideComplete_;
			
	bool reactToAbort_;
	bool reactToStop_;
	bool reactToClear_;
	bool reactToReset_;
	bool reactToStart_;
	bool reactToSuspend_;
	bool reactToUnsuspend_;
	bool reactToHold_;
	bool reactToUnhold_;
	bool reactToComplete_;

	bool escalateAbort_;
	bool escalateStop_;
	bool escalateClear_;
	bool escalateReset_;
	bool escalateStart_;
	bool escalateSuspend_;
	bool escalateUnsuspend_;
	bool escalateHold_;
	bool escalateUnhold_;
	bool escalateComplete_;


	// ****************** Hierarchy related stuff ***********************

	// Pointers to the parent/childs in the hierarchy
	// Change it to smart pointers
	PackMLModule* pParentLink_;
	std::vector<PackMLModule*> childLinks_;
	unsigned long int parentLinkAdr_;

	// Configure the hierarchy
	bool linkToParent_(PackMLModule* pParent);
	bool unlinkFromParent_();

	bool hasParent_;
	unsigned long childCount_;
	unsigned short hierarchyLevel_;

	bool moduleReady_;

	// *************** PackML State Manager *******************
	long int modeCurrent_;
	PackMLModuleStateEnu stateCurrent_;
	long int subStateCurrent_;

	bool activate_;
	bool deactivate_;

	// Internal cmds
	bool abort_;
	bool clear_;
	bool stop_;
	bool reset_;
	bool start_;
	bool hold_;
	bool unhold_;
	bool suspend_;
	bool unsuspend_;
	bool complete_;
	bool stateComplete_;
			
	bool oldAbort_;
	bool oldClear_;
	bool oldStop_;
	bool oldReset_;
	bool oldStart_;
	bool oldHold_;
	bool oldUnhold_;
	bool oldSuspend_;
	bool oldUnsuspend_;
	bool oldComplete_;
	bool oldStateComplete_;

	bool externalAbort_;
	bool externalClear_;
	bool externalStop_;
	bool externalReset_;
	bool externalStart_;
	bool externalHold_;
	bool externalUnhold_;
	bool externalSuspend_;
	bool externalUnsuspend_;
	bool externalComplete_;
	bool externalStateComplete_;

	void updatePackMLModel_();

	void checkActivationCondition_();

	void checkParentStateCondition_();
			
	bool setCmd_(PackMLModuleStateEnu targetActingState);
	void resetCmd_(PackMLModuleStateEnu targetActingState);

	void executeCmd_(PackMLModuleStateEnu targetState);

	void executeActingState_(PackMLModuleStateEnu targetState);


	bool stateExistInPattern_(unsigned long stateBitPattern,
	PackMLModuleStateEnu state);
	
	bool cmdValid_(PackMLModuleStateEnu state);
	// Checks if the all the children are in the provided state
	bool childrenInState_(PackMLModuleStateEnu state);
	// Checks if the children are in need of synchronisation for the provided
	// state
	bool childrenInSynch_(PackMLModuleStateEnu targetState);
	
	bool isChild_(PackMLModule* pModule);

	// Reset the cmds, substate, status etc when a state changes
	void resetInternalCmds_();

	// Waiting for and aborted by related stuff
	void setWaitingFor_();
	void resetWaitingFor_();
	void setInteruptedBy_();
	void resetInteruptedBy_();
	
	PackMLModuleSharedInfo* pWaitingFor_;
	PackMLModuleSharedInfo* pInteruptedBy_;
	
	bool activationPv_;
	float timeInState_;
	float timeInSubState_;
	float cycleTime_; // ms
	
	void updateTimeInState_() {
		timeInState_ += cycleTime_;
		timeInSubState_ += cycleTime_;
	}
	
	void* pUserData_;
	unsigned long int userDataSize_;


};



#endif // __MAPP_MXPACKML_PACKMLMODULE_HPP__
