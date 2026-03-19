#include "BrdkPackML.h"
#include "../PackMLCore/PackMLModule.hpp"
#include "../PackMLCore/PackMLModuleTable.hpp"

extern unsigned long bur_heap_size;

extern PackMLModuleTable* pPackMLModuleTable;


// Main function. Is running cyclic together with FUB EquipmentModule()
void run(struct ControlModule* inst, PackMLModule* pPackMLModule)
{

	if (inst->Info.OnStateEntry){
		inst->Info.OnStateEntry = false;
	}
	if (inst->Info.OnSubStateEntry){
		inst->Info.OnSubStateEntry = false;
	}
	
	if(inst->Internal.oldSubState != inst->SubState){
		if(inst->Setup.AuditSubStateChange){
			
			for(unsigned short int i = 0; i < EM_MAX_AUDIT_ENTRIES; i++){
				strcpy(inst->Info.Last[EM_MAX_AUDIT_ENTRIES - i], inst->Info.Last[(EM_MAX_AUDIT_ENTRIES - 1) - i]);
			}
			sprintf(inst->Info.Last[0], "Substate: %ld, time: %2.1f s.", inst->Internal.oldSubState, inst->Info.TimeInSubState);
		}
		inst->Internal.oldSubState = inst->SubState;
		inst->Info.TimeInSubState = 0.0;
		inst->Info.OnSubStateEntry = true;
	}


	// Update the FB info
	// State info
	if (inst->State != inst->Internal.oldState) {
		
		if(inst->Setup.AuditStateChange){
			
			for(unsigned short int i = 0; i < EM_MAX_AUDIT_ENTRIES; i++){
				strcpy(inst->Info.Last[EM_MAX_AUDIT_ENTRIES - i], inst->Info.Last[(EM_MAX_AUDIT_ENTRIES - 1) - i]);
			}
			sprintf(inst->Info.Last[0], "State: %ld, time: %2.1f s.", inst->Internal.oldState, inst->Info.TimeInState);
		}
		
		inst->Internal.oldState = inst->State;

		inst->SubState = 0;
		inst->Internal.oldSubState = 0;
		inst->StateInfo[0] = 0;
		inst->Info.TimeInState = 0.0;
		inst->Info.TimeInSubState = 0.0;
		inst->Info.OnStateEntry = true;
		inst->Info.OnSubStateEntry = true;
		
	}
	
	inst->Info.TimeInState += inst->Internal.cycleTime;
	inst->Info.TimeInSubState += inst->Internal.cycleTime;
	
	// Parent / Child / Sibling state/substate info
	if (pPackMLModule != nullptr){
		inst->Info.Level = pPackMLModule->getHierarchyLevel() + 1;
		inst->Info.ParentStateCurrent = static_cast<EMPackMLStateEnum>(pPackMLModule->getCurrentState());
	} else {
		inst->Info.Level = 0;
		inst->Info.ParentStateCurrent = STATE_UNDEFINED;
	}
	
	
	if(inst->Interface.Enable){
		inst->Internal.oldPubSubEnable = true;
		
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

void ControlModule(struct ControlModule* inst)
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
				
				strcpy(inst->Info.CmName, moduleName);
				
				RTInfo_typ RTInfo_0;
				RTInfo_0.enable = 1;
				RTInfo(&RTInfo_0);
				inst->Internal.cycleTime = static_cast<float>(RTInfo_0.cycle_time) * 0.000001;
				inst->Info.CycleTime = inst->Internal.cycleTime;
				inst->Internal.state = 30;
			}
			break;
		
		case 30: // Init EM phase // interlinking
			{
				if(strlen(inst->Setup.ParentName) > 0){
					inst->Internal.state = 35;	
				} else {
					inst->Internal.state = 40;
				}
				strcpy(inst->Info.ParentName, inst->Setup.ParentName);
			}
			break;
		
		case 35:
			{
				
				PackMLModule* pPackMLModule = pPackMLModuleTable->getModuleByName(inst->Info.ParentName);

				if(strcmp(inst->Setup.ParentName, inst->Info.ParentName) != 0){
					inst->Internal.state = 30;
					
				} else if(pPackMLModule != nullptr){
					inst->Internal.parentEmAddress = reinterpret_cast<unsigned long int>(pPackMLModule);
					inst->Info.ParentEmAddress = inst->Internal.parentEmAddress;
					inst->Info.ParentEmIndex = pPackMLModuleTable->getModuleIndexByName(inst->Info.ParentName);
					inst->Internal.state = 40;
				}
			
			}
			break;
		
		case 40: // run state
			// if EmLinkParent changes reinitilise the module in state 30
			{    
				PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(inst->Internal.parentEmAddress);
                
				if(strcmp(inst->Setup.ParentName, inst->Info.ParentName) != 0){
					inst->Info.ParentName[0] = 0;
					inst->Info.ParentEmAddress = 0;
					inst->Info.ParentEmIndex = 0;
					inst->Internal.parentEmAddress = 0;
					inst->Internal.state = 30;
				}
				run(inst, pPackMLModule);
			}
			break;
	}
	
}