#include "BrdkPackML.h"
#include "../PackMLCore/PackMLModule.hpp"
#include "../PackMLCore/PackMLModuleTable.hpp"

extern unsigned long bur_heap_size;

extern PackMLModuleTable* pPackMLModuleTable;


// Main function. Is running cyclic together with FUB EquipmentModule()
void run(struct EquipmentModule* inst, PackMLModule* pPackMLModule)
{
	// Reading Setup structure
	pPackMLModule->setActivationCondition(static_cast<short int>(inst->Setup.ActivationCondition));
	pPackMLModule->setActivationPv(inst->Setup.Activate);
	
	pPackMLModule->setOverrideAbort(inst->Setup.Synchronisation.Override.Abort);
	pPackMLModule->setOverrideStop(inst->Setup.Synchronisation.Override.Stop);
	pPackMLModule->setOverrideComplete(inst->Setup.Synchronisation.Override.Complete);
	pPackMLModule->setOverrideSuspend(inst->Setup.Synchronisation.Override.Suspend);
	pPackMLModule->setOverrideUnsuspend(inst->Setup.Synchronisation.Override.Unsuspend);
	pPackMLModule->setOverrideHold(inst->Setup.Synchronisation.Override.Hold);
	pPackMLModule->setOverrideUnhold(inst->Setup.Synchronisation.Override.Unhold);
	pPackMLModule->setOverrideClear(inst->Setup.Synchronisation.Override.Clear);
	pPackMLModule->setOverrideReset(inst->Setup.Synchronisation.Override.Reset);
	pPackMLModule->setOverrideStart(inst->Setup.Synchronisation.Override.Start);

	pPackMLModule->setReactToAbort(inst->Setup.Synchronisation.ReactTo.Abort);
	pPackMLModule->setReactToStop(inst->Setup.Synchronisation.ReactTo.Stop);
	pPackMLModule->setReactToComplete(inst->Setup.Synchronisation.ReactTo.Complete);
	pPackMLModule->setReactToSuspend(inst->Setup.Synchronisation.ReactTo.Suspend);
	pPackMLModule->setReactToUnsuspend(inst->Setup.Synchronisation.ReactTo.Unsuspend);
	pPackMLModule->setReactToHold(inst->Setup.Synchronisation.ReactTo.Hold);
	pPackMLModule->setReactToUnhold(inst->Setup.Synchronisation.ReactTo.Unhold);
	pPackMLModule->setReactToClear(inst->Setup.Synchronisation.ReactTo.Clear);
	pPackMLModule->setReactToReset(inst->Setup.Synchronisation.ReactTo.Reset);
	pPackMLModule->setReactToStart(inst->Setup.Synchronisation.ReactTo.Start);	

	pPackMLModule->setEscalateAbort(inst->Setup.Synchronisation.Escalate.Abort);
	pPackMLModule->setEscalateStop(inst->Setup.Synchronisation.Escalate.Stop);
	pPackMLModule->setEscalateComplete(inst->Setup.Synchronisation.Escalate.Complete);
	pPackMLModule->setEscalateSuspend(inst->Setup.Synchronisation.Escalate.Suspend);
	pPackMLModule->setEscalateUnsuspend(inst->Setup.Synchronisation.Escalate.Unsuspend);
	pPackMLModule->setEscalateHold(inst->Setup.Synchronisation.Escalate.Hold);
	pPackMLModule->setEscalateUnhold(inst->Setup.Synchronisation.Escalate.Unhold);
	pPackMLModule->setEscalateClear(inst->Setup.Synchronisation.Escalate.Clear);
	pPackMLModule->setEscalateReset(inst->Setup.Synchronisation.Escalate.Reset);
	pPackMLModule->setEscalateStart(inst->Setup.Synchronisation.Escalate.Start);
	
	
	if (inst->Info.OnStateEntry){
		inst->Info.OnStateEntry = false;
	}
	if (inst->Info.OnSubStateEntry){
		inst->Info.OnSubStateEntry = false;
	}

	long int oldSubstate = pPackMLModule->getCurrentSubState();
	if(oldSubstate != inst->SubState){
		if(inst->Setup.AuditSubStateChange){
			
			for(unsigned short int i = 0; i < EM_MAX_AUDIT_ENTRIES; i++){
				strcpy(inst->Info.Last[EM_MAX_AUDIT_ENTRIES - i], inst->Info.Last[(EM_MAX_AUDIT_ENTRIES - 1) - i]);
			}
			sprintf(inst->Info.Last[0], "Substate: %ld, time: %2.1f s.", oldSubstate, inst->Info.TimeInSubState);
		}
		pPackMLModule->setCurrentSubState(inst->SubState);
		inst->Info.OnSubStateEntry = true;
	}
	std::string oldStateInfo = pPackMLModule->getStateInfo();
	if(oldStateInfo != inst->StateInfo){
		pPackMLModule->setStateInfo(inst->StateInfo);
	}
	
	if(inst->SetModeID != inst->ModeID){
		// Restrict mode changes to certain states could be defined here: (-And also in the function EMSetMode())
		if (!pPackMLModule->setCurrentMode(inst->SetModeID)){
			inst->SetModeID = inst->ModeID;
		}
		
	}

	pPackMLModule->evaluateCmdAbort(inst->Command.Abort);
	pPackMLModule->evaluateCmdStop(inst->Command.Stop);
	pPackMLModule->evaluateCmdClear(inst->Command.Clear);
	pPackMLModule->evaluateCmdReset(inst->Command.Reset);
	pPackMLModule->evaluateCmdStart(inst->Command.Start);
	pPackMLModule->evaluateCmdSuspend(inst->Command.Suspend);
	pPackMLModule->evaluateCmdUnsuspend(inst->Command.Unsuspend);
	pPackMLModule->evaluateCmdHold(inst->Command.Hold);
	pPackMLModule->evaluateCmdUnhold(inst->Command.Unhold);
	pPackMLModule->evaluateCmdComplete(inst->Command.Complete);
	pPackMLModule->evaluateCmdStateComplete(inst->Command.StateComplete);
	
	if(inst->Setup.SkipStopStateComplete && pPackMLModule->getCmdStop()){
		pPackMLModule->setCmdStateComplete();
	}

	//--- End of things to handle before EM is being executed from lib on heap ---//
	
	// Run the packmlmodule service
	pPackMLModule->runPackMLModule();
	
	EMPackMLStateEnum stateCurrent = static_cast<EMPackMLStateEnum>(pPackMLModule->getCurrentState());
	// Update the FB info
	// State info
	if (inst->StateCurrent != stateCurrent) {
		
		if(inst->Setup.AuditStateChange){
			plcstring* oldStateStr = (plcstring*)pPackMLModule->getStateStr(static_cast<PackMLModuleStateEnu>(inst->StateCurrent));
			
			for(unsigned short int i = 0; i < EM_MAX_AUDIT_ENTRIES; i++){
				strcpy(inst->Info.Last[EM_MAX_AUDIT_ENTRIES - i], inst->Info.Last[(EM_MAX_AUDIT_ENTRIES - 1) - i]);
			}
			sprintf(inst->Info.Last[0], "State: %s, time: %2.1f s.", oldStateStr, inst->Info.TimeInState);
		}
		
		inst->StateCurrent = stateCurrent;

		inst->SubState = 0;
		pPackMLModule->setCurrentSubState(inst->SubState);
		inst->StateInfo[0] = 0;
		inst->Info.OnStateEntry = true;
		inst->Info.OnSubStateEntry = true;

		// Reset Cmds
		memset(&inst->Command, 0, sizeof(inst->Command));
		
	}
	
	inst->Info.TimeInState = pPackMLModule->getTimeInState();
	inst->Info.TimeInSubState = pPackMLModule->getTimeInSubState();
	
	inst->Info.ParentStateCurrent = static_cast<EMPackMLStateEnum>(pPackMLModule->getParentCurrentState());
	
	// Parent / Child / Sibling state/substate info
	inst->Info.ParentStateComplete = pPackMLModule->getParentStateComplete();
	inst->Info.SiblingsStateComplete = pPackMLModule->getSiblingsStateComplete();
	inst->Info.ChildrenStateComplete = pPackMLModule->getChildrenStateComplete();

	inst->Info.Level = pPackMLModule->getHierarchyLevel();
	inst->Info.ChildCount = pPackMLModule->getChildCount();
	inst->Info.SiblingCount = pPackMLModule->getSiblingCount();

	// Mode info
	if (inst->ModeID != pPackMLModule->getCurrentMode()) {
		
		if(inst->Setup.AuditStateChange){

			
			for(unsigned short int i = 0; i < EM_MAX_AUDIT_ENTRIES; i++){
				strcpy(inst->Info.Last[EM_MAX_AUDIT_ENTRIES - i], inst->Info.Last[(EM_MAX_AUDIT_ENTRIES - 1) - i]);
			}
			sprintf(inst->Info.Last[0], "ModeID: %d --> %ld", inst->ModeID, pPackMLModule->getCurrentMode());
		}
		
		inst->ModeID = static_cast<EMPackMLModeEnum>(pPackMLModule->getCurrentMode());
		inst->SetModeID = inst->ModeID ;
		
		inst->SubState = 0;
		pPackMLModule->setCurrentSubState(inst->SubState);
		inst->StateInfo[0] = 0;
	}

	if(inst->Setup.EnableInteruptedBy){
		PackMLModuleSharedInfo* pInteruptedBy =  pPackMLModule->getInteruptedByPtr();
		if(pInteruptedBy != nullptr){
			inst->Info.InteruptedBy.ModeID = inst->ModeID;
			inst->Info.InteruptedBy.StateCurrent = static_cast<EMPackMLStateEnum>(pInteruptedBy->getStateCurrent());
			inst->Info.InteruptedBy.SubStateCurrent = pInteruptedBy->getSubStateCurrent();
			inst->Info.InteruptedBy.StateComplete = pInteruptedBy->getStateComplete();
			strcpy(inst->Info.InteruptedBy.Name, pInteruptedBy->getName());
			strcpy(inst->Info.InteruptedBy.StateInfo, pInteruptedBy->getStateInfo());
		}
	}
	
	if(inst->Setup.EnableWaitingFor){
		PackMLModuleSharedInfo* pWaitingFor =  pPackMLModule->getWaitingForPtr();
		if(pWaitingFor != nullptr){
			inst->Info.WaitingFor.ModeID = inst->ModeID;
			inst->Info.WaitingFor.StateCurrent = static_cast<EMPackMLStateEnum>(pWaitingFor->getStateCurrent());
			inst->Info.WaitingFor.SubStateCurrent = pWaitingFor->getSubStateCurrent();
			inst->Info.WaitingFor.StateComplete = pWaitingFor->getStateComplete();
			strcpy(inst->Info.WaitingFor.Name, pWaitingFor->getName());
			strcpy(inst->Info.WaitingFor.StateInfo, pWaitingFor->getStateInfo());
		}
	}

	if(inst->Interface.Enable){
		inst->Internal.oldPubSubEnable = true;
		
		memcpy(reinterpret_cast<EMUserDataPubSubType*>(inst->Internal.userDataAddress), reinterpret_cast<EMUserDataPubSubType*>(&inst->Interface.Publish), sizeof(EMUserDataPubSubType));
		
		for(unsigned short int i = 0; i < EM_MAX_SUBSCRIPTIONS + 1; i++){
		
			if(inst->Interface.SubscriptionValid[i]){
				memcpy(reinterpret_cast<EMUserDataPubSubType*>(&inst->Interface.Subscribe[i]), reinterpret_cast<EMUserDataPubSubType*>(inst->Internal.subscriptionUserDataAddress[i]), sizeof(EMUserDataPubSubType));
			}
		
			if(strcmp(inst->Interface.SubscriptionEMName[i], inst->Internal.subscribedToEMName[i]) != 0){
				PackMLModule* pSubscribtionEm = pPackMLModuleTable->getModuleByName(inst->Interface.SubscriptionEMName[i]);
				if(pSubscribtionEm != nullptr){
					inst->Internal.subscriptionUserDataAddress[i] = reinterpret_cast<unsigned long int>(pSubscribtionEm->getUserMemoryPtr());
					inst->Interface.SubscriptionValid[i] = true;
					strcpy(inst->Internal.subscribedToEMName[i], inst->Interface.SubscriptionEMName[i]);
				} else {
					inst->Interface.SubscriptionValid[i] = false;	
					inst->Internal.subscriptionUserDataAddress[i] = 0;
					inst->Internal.subscribedToEMName[i][0] = 0;
				}
				
				memset(reinterpret_cast<EMUserDataPubSubType*>(&inst->Interface.Subscribe[i]), 0, sizeof(EMUserDataPubSubType));
				
			}
		
		}
	} else if(not inst->Interface.Enable && inst->Internal.oldPubSubEnable){
		inst->Internal.oldPubSubEnable = false;
		memset(reinterpret_cast<EMUserDataPubSubType*>(&inst->Interface.Subscribe), 0, sizeof(EMUserDataPubSubType) * (EM_MAX_SUBSCRIPTIONS + 1));
		memset(reinterpret_cast<bool*>(&inst->Interface.SubscriptionValid), 0, sizeof(bool) * (EM_MAX_SUBSCRIPTIONS + 1));
		memset(reinterpret_cast<unsigned long int*>(&inst->Internal.subscriptionUserDataAddress), 0, sizeof(unsigned long int) * (EM_MAX_SUBSCRIPTIONS + 1));
		memset(reinterpret_cast<char*>(&inst->Internal.subscribedToEMName), 0, 256 * (EM_MAX_SUBSCRIPTIONS + 1));
	}

}


// ------------ IEC Functions and Function Blocks -----------------------------------------

void EquipmentModule(struct EquipmentModule* inst)
{

	// Initialize the module	
	switch(inst->Internal.state){
		
		case 0: 
			{
				// get name
				if(strlen(inst->Setup.Name) == 0){
					ST_name(0, inst->Setup.Name, 0);
				}
				
				char moduleName[256] = {""};
				
				if (inst->Setup.NameIndex == EM_MAX_NAME_INDEX){
					strcpy(moduleName, inst->Setup.Name);
				} else {
					sprintf(moduleName, "%s%d", inst->Setup.Name, inst->Setup.NameIndex);
				}
				
				// check if object exists
				PackMLModule* pPackMLModule = pPackMLModuleTable->getModuleByName(moduleName);
				
				
				// Create a new module if not exists
				if(pPackMLModule == nullptr){
					RTInfo_typ RTInfo_0;
					RTInfo_0.enable = 1;
					RTInfo(&RTInfo_0);
					
					pPackMLModule = new PackMLModule(moduleName);
					pPackMLModule->setCycleTime(static_cast<float>(RTInfo_0.cycle_time) * 0.000001);
					inst->Info.CycleTime = static_cast<float>(RTInfo_0.cycle_time) * 0.000001;
					
					// Create userData for misc usage e.g. sync and priority, and get pointer.
					inst->Internal.userDataAddress = reinterpret_cast<unsigned long int>(pPackMLModule->createUserMemory(sizeof(EMUserDataPubSubType)));
					inst->Internal.state = 20;
				} else {
					// We should copy all the options from the heap to the IEC on stack
					strcpy(inst->Setup.ParentName, pPackMLModule->getParentName());
					strcpy(inst->Info.ParentName, inst->Setup.ParentName);
					
					inst->Internal.userDataAddress = reinterpret_cast<unsigned long int>(pPackMLModule->getUserMemoryPtr());
					inst->Info.EmIndex = pPackMLModuleTable->getModuleIndexByName(moduleName);
					
					inst->Internal.state = 40;
				}
				
				inst->Internal.emAddress = reinterpret_cast<unsigned long int>(pPackMLModule);
				inst->Info.EmAddress = inst->Internal.emAddress;
				inst->Info.UserDataAddress = inst->Internal.userDataAddress;
				strcpy(inst->Info.EmName, moduleName);
				
			}
			break;
		
		case 20: // register the object
			if(pPackMLModuleTable->registerEm(inst->Internal.emAddress, &inst->Info.EmIndex)){
				inst->Internal.state = 30;
			}
			break;
		
		case 30: // Init EM phase // interlinking
			{
				PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(inst->Internal.emAddress);

				if(strlen(inst->Setup.ParentName) > 0){
					inst->Internal.state = 35;	
				} else {
					pPackMLModule->initModule();
					inst->Internal.state = 40;
				}
				strcpy(inst->Info.ParentName, inst->Setup.ParentName);
				
				// **** do we need it here?? test
				//				pPackMLModule->runPackMLModule();
			}
			break;
		
		case 35:
			{
				PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(inst->Internal.emAddress);
				// Can get stucked here --> **inst->Info.ParentName**
				if(strcmp(inst->Setup.ParentName, inst->Info.ParentName) != 0){
					inst->Internal.state = 30;
				} else if(pPackMLModule->initModule(reinterpret_cast<PackMLModule*>(pPackMLModuleTable->getModuleByName(inst->Info.ParentName)))){
					//					strcpy(inst->Info.ParentName, pPackMLModule->getParentName());
					inst->Internal.state = 40;
				}
			
			}
			break;
		
		case 40: // run state
			// if EmLinkParent changes reinitilise the module in state 30
			{    
				PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(inst->Internal.emAddress);
                
				if(strcmp(inst->Setup.ParentName, inst->Info.ParentName) != 0){
					inst->Internal.state = 50;
				} else {
					run(inst, pPackMLModule);
				}
				
			}
			break;
        
        
		case 50: // exit module and go to state 10
			{
				PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(inst->Internal.emAddress);
                
				if(pPackMLModule->exitModule()){
					inst->Internal.state = 30;
					
					if(inst->Setup.AuditStateChange){
						plcstring* oldStateStr = (plcstring*)pPackMLModule->getStateStr(static_cast<PackMLModuleStateEnu>(inst->StateCurrent));
			
						for(unsigned short int i = 0; i < EM_MAX_AUDIT_ENTRIES; i++){
							strcpy(inst->Info.Last[EM_MAX_AUDIT_ENTRIES - i], inst->Info.Last[(EM_MAX_AUDIT_ENTRIES - 1) - i]);
						}
						sprintf(inst->Info.Last[0], "State: %s, time: %2.1f s.", oldStateStr, inst->Info.TimeInState);
					}
					
					inst->Info.TimeInState = 0;
					inst->Info.ParentName[0] = 0;
					inst->Info.ParentStateCurrent = STATE_UNDEFINED;
					inst->Info.ParentStateComplete = false;
					inst->Info.Level = 0;
					inst->Info.SiblingCount = 1;
					inst->StateCurrent = STATE_UNDEFINED;
					inst->SubState = 0;
					inst->StateInfo[0] = 0;
					memset(&inst->Command, 0, sizeof(inst->Command));
				}

			}
			break;
	}
	
}