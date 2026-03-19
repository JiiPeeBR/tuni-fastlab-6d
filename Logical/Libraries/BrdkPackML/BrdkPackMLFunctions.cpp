#include "BrdkPackML.h"
#include "../PackMLCore/PackMLModule.hpp"
#include "../PackMLCore/PackMLModuleTable.hpp"

unsigned long bur_heap_size = 0x3CCCC;

PackMLModuleTable* pPackMLModuleTable = new PackMLModuleTable();


	
//---------------------- IEC Functions ----------------------------------//
bool EMSetMode(unsigned long EmAddress, signed long Mode)
{
	if(EmAddress == 0){
		return false;
	}
	
	PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(EmAddress);
	
	return pPackMLModule->setCurrentMode(Mode);
	
}

bool EMSetModeByName(plcstring* EmName, signed long Mode)
{
	PackMLModule* pPackMLModule = pPackMLModuleTable->getModuleByName(EmName);
	
	if(pPackMLModule == nullptr)
		return false;

	return pPackMLModule->setCurrentMode(Mode);
	
}


plcbit EMGetModuleStatusByName(plcstring* EmName, struct EMStatusType* EMStatus){
	
	PackMLModule* pPackMLModule = pPackMLModuleTable->getModuleByName(EmName);
	
	if(EMStatus == 0 || pPackMLModule == nullptr){
		return false;
	}

	EMStatus->ModeID = pPackMLModule->getCurrentMode();
	strcpy(EMStatus->Name, pPackMLModule->getModuleName());
	EMStatus->StateComplete = pPackMLModule->getStateComplete();
	EMStatus->StateCurrent = static_cast<EMPackMLStateEnum>(pPackMLModule->getCurrentState());
	EMStatus->SubStateCurrent = pPackMLModule->getCurrentSubState();
	strcpy(EMStatus->StateInfo, pPackMLModule->getStateInfo());
		
	return true;
}

plcbit EMGetWaitingForByIdx(unsigned long EmIdx, struct EMStatusType* WaitingFor){
	PackMLModule* pPackMLModule = pPackMLModuleTable->getRootModuleByIdx(EmIdx);

	if(WaitingFor == 0 || pPackMLModule == nullptr){
		return false;
	}
	// Get waiting for info 
	PackMLModuleSharedInfo* pWaitingFor =  pPackMLModule->getWaitingForPtr();
	if(pWaitingFor != nullptr){
		WaitingFor->ModeID = pWaitingFor->getModeCurrent();
		WaitingFor->StateCurrent = static_cast<EMPackMLStateEnum>(pWaitingFor->getStateCurrent());
		WaitingFor->SubStateCurrent = pWaitingFor->getSubStateCurrent();
		WaitingFor->StateComplete = pWaitingFor->getStateComplete();
		strcpy(WaitingFor->Name, pWaitingFor->getName());
		strcpy(WaitingFor->StateInfo, pWaitingFor->getStateInfo());	
	} else {
		memset(&WaitingFor, 0, sizeof(WaitingFor));
	}
	return true;
}

plcbit EMGetInterruptedByByIdx(unsigned long EmIdx, struct EMStatusType* InterruptedBy){
	PackMLModule* pPackMLModule = pPackMLModuleTable->getRootModuleByIdx(EmIdx);

	if(InterruptedBy == 0 || pPackMLModule == nullptr){
		return false;
	}
	// Get interrupted by info
	PackMLModuleSharedInfo* pInteruptedBy =  pPackMLModule->getInteruptedByPtr();
	if(pInteruptedBy != nullptr){
		InterruptedBy->ModeID = pInteruptedBy->getModeCurrent();
		InterruptedBy->StateCurrent = static_cast<EMPackMLStateEnum>(pInteruptedBy->getStateCurrent());
		InterruptedBy->SubStateCurrent = pInteruptedBy->getSubStateCurrent();
		InterruptedBy->StateComplete = pInteruptedBy->getStateComplete();
		strcpy(InterruptedBy->Name, pInteruptedBy->getName());
		strcpy(InterruptedBy->StateInfo, pInteruptedBy->getStateInfo());	
	} else {
		memset(&InterruptedBy, 0, sizeof(InterruptedBy));
	}
	return true;
}


unsigned long EMGetModuleAdrByName(plcstring* EmName){
	
	return reinterpret_cast<unsigned long int>(pPackMLModuleTable->getModuleByName(EmName));
}

unsigned long EMGetModuleAdrByIdx(unsigned long EmIdx){
	
	return reinterpret_cast<unsigned long int>(pPackMLModuleTable->getModuleByIdx(EmIdx));
}


plcbit EMGetModuleStatus(unsigned long EmAddress, struct EMStatusType* EMStatus){
	
	if(EmAddress == 0 || EMStatus == 0){
		return false;
	}
	
	PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(EmAddress);
	
	EMStatus->ModeID = pPackMLModule->getCurrentMode();
	strcpy(EMStatus->Name, pPackMLModule->getModuleName());
	EMStatus->StateComplete = pPackMLModule->getStateComplete();
	EMStatus->StateCurrent = static_cast<EMPackMLStateEnum>(pPackMLModule->getCurrentState());
	EMStatus->SubStateCurrent = pPackMLModule->getCurrentSubState();
	strcpy(EMStatus->StateInfo, pPackMLModule->getStateInfo());
	
		
	return true;
}


unsigned long EMGetNumberOfModules(){
	return pPackMLModuleTable->getNumberOfModules();
}

unsigned long EMGetNumberOfRootModules(){
	return pPackMLModuleTable->getNumberOfRoots();
}

plcbit EMGetModuleStatusByIdx(unsigned long EmIdx, struct EMStatusType* EMStatus){
	
	if(EMStatus == 0){
		return false;
	}
	
	PackMLModule* pPackMLModule = pPackMLModuleTable->getModuleByIdx(EmIdx);
	
	EMStatus->ModeID = pPackMLModule->getCurrentMode();
	strcpy(EMStatus->Name, pPackMLModule->getModuleName());
	EMStatus->StateComplete = pPackMLModule->getStateComplete();
	EMStatus->StateCurrent = static_cast<EMPackMLStateEnum>(pPackMLModule->getCurrentState());
	EMStatus->SubStateCurrent = pPackMLModule->getCurrentSubState();
	strcpy(EMStatus->StateInfo, pPackMLModule->getStateInfo());
		
	return true;
}

unsigned long EMGetParentAdr(unsigned long EmAddress){
	
	if(EmAddress == 0){
		return 0;
	}
	return reinterpret_cast<unsigned long int>(reinterpret_cast<PackMLModule*>(EmAddress)->getParentPtr());
		}
unsigned long EMGetChildrenAdrByIdx(unsigned long EmAddress, unsigned long EmIdx){
	
	if(EmAddress == 0){
		return 0;
	}
	
	return reinterpret_cast<unsigned long int>(reinterpret_cast<PackMLModule*>(EmAddress)->getChildPtr(EmIdx));

		}
unsigned long EMGetSiblingAdrByIdx(unsigned long EmAddress, unsigned long EmIdx){
	
	if(EmAddress == 0){
		return 0;
	}
	
	return reinterpret_cast<unsigned long int>(reinterpret_cast<PackMLModule*>(EmAddress)->getSiblingPtr(EmIdx));

		}
unsigned long EMGetRootAdrByIdx(unsigned long EmIdx){
	
	return reinterpret_cast<unsigned long int>(pPackMLModuleTable->getRootModuleByIdx(EmIdx));

}
unsigned long EMGetUserDataAdr(unsigned long EmAddress){
	
	if(EmAddress == 0){
		return 0;
	}
	return reinterpret_cast<unsigned long int>(reinterpret_cast<PackMLModule*>(EmAddress)->getUserMemoryPtr());

		}

plcbit EMSetCommand(unsigned long EmAddress, unsigned long EmAddressInterrupter, enum EMPackMLCmdEnum Command){
	
	if(EmAddress == 0){
		return false;
	}
	
	PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(EmAddress);
	
	switch(Command){
	
		case CMD_ABORT:
			pPackMLModule->setCmdAbort();
			break;
		
		case CMD_STOP:
			pPackMLModule->setCmdStop();
			break;
		
		case CMD_CLEAR:
			pPackMLModule->setCmdClear();
			break;
		
		case CMD_RESET:
			pPackMLModule->setCmdReset();
			break;

		case CMD_START:
			pPackMLModule->setCmdStart();
			break;
		
		case CMD_HOLD:
			pPackMLModule->setCmdHold();
			break;
		
		case CMD_UNHOLD:
			pPackMLModule->setCmdUnhold();
			break;
		
		case CMD_SUSPEND:
			pPackMLModule->setCmdSuspend();
			break;
		
		case CMD_UNSUSPEND:
			pPackMLModule->setCmdUnsuspend();
			break;
		
		case CMD_COMPLETE:
			pPackMLModule->setCmdComplete();
			break;
	
		case CMD_SC:
			pPackMLModule->setCmdStateComplete();
			break;
		
		default:
			return false;

	}
	
	if(EmAddressInterrupter == 0){
		pPackMLModule->setInteruptedBy(pPackMLModule);
	} else {
		pPackMLModule->setInteruptedBy(reinterpret_cast<PackMLModule*>(EmAddressInterrupter));
	}
	
	return true;

}


unsigned long EMGetModuleIdxByName(plcstring* EmName){
	
	if(EmName == nullptr){
		return 0xFFFFFFFF;
	}
	
	return pPackMLModuleTable->getModuleIndexByName(EmName);

}