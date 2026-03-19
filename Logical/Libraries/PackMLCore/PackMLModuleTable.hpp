#ifndef __PACKMLMODULETABLE_HPP__
#define __PACKMLMODULETABLE_HPP__

#include "PackMLModule.hpp"

class PackMLModuleTable 
{
	public:
	// add public members and methods
	PackMLModuleTable() : semaphore_(), em_() {

	}
    
	PackMLModule* getModuleByName(const char* pName){
		unsigned long int moduleId = generateId_(pName);
		
		if(moduleId == 0)
			return nullptr;
		
		for(unsigned long int i = 0; i < em_.size(); i++ ){
			if(em_[i]->getModuleId() == moduleId){
				return em_[i];
			}
		}
		return nullptr;
	}
	
	unsigned long int getModuleIndexByName(const char* pName){
		unsigned long int moduleId = generateId_(pName);
		
		if(moduleId == 0)
			return 0xFFFFFFFF;
		
		for(unsigned long int i = 0; i < em_.size(); i++ ){
			if(em_[i]->getModuleId() == moduleId){
				return i;
			}
		}
		return 0xFFFFFFFF;
	}
	
	PackMLModule* getModuleByIdx(unsigned long int idx){
		return em_[idx % em_.size()];
	}
	
	bool registerEm(unsigned long int moduleAdr, unsigned long int* moduleIndex = nullptr){
		
		if(!semaphore_.acquire())
			return false;
		
		PackMLModule* pPackMLModule = reinterpret_cast<PackMLModule*>(moduleAdr);
		pPackMLModule = getModuleByName(pPackMLModule->getModuleName());
		
		if(pPackMLModule == nullptr){
			em_.push_back(reinterpret_cast<PackMLModule*>(moduleAdr));
			
			if(moduleIndex != nullptr){
				*moduleIndex = em_.size() - 1;
			}	
		} else {
			if(moduleIndex != nullptr){
				*moduleIndex = getModuleIndexByName(pPackMLModule->getModuleName());
			}
		}
			
		semaphore_.release();
		return true;
	}
		
		
	bool registerEm(PackMLModule* pEm, unsigned long int* moduleIndex = nullptr){
		
		if(!semaphore_.acquire())
			return false;
		
		PackMLModule* pPackMLModule = getModuleByName(pEm->getModuleName());
		
		if(pPackMLModule == nullptr){
			em_.push_back(pEm);
			
			if(moduleIndex != nullptr){
				*moduleIndex = em_.size() - 1;
			}	
		} else {
			if(moduleIndex != nullptr){
				*moduleIndex = getModuleIndexByName(pPackMLModule->getModuleName());
			}
		}
		
		semaphore_.release();
		return true;
	}
	
	unsigned long int getNumberOfRoots(){
		unsigned long int rootIdx = 0;
		
		for(unsigned long int i = 0; i < em_.size(); i++ ){
			if(em_[i]->getHierarchyLevel() == 0){
				rootIdx++;
			}
		}
		return rootIdx;
	}
	
	unsigned long int getNumberOfModules(){
		return em_.size();
	}
	
	PackMLModule* getRootModuleByIdx(unsigned long int idx){
		
		unsigned long int rootIdx = 0;
		
		for(unsigned long int i = 0; i < em_.size(); i++ ){
			if(em_[i]->getHierarchyLevel() == 0){
				
				if(rootIdx == idx)
					return em_[i];
				
				rootIdx++;
			}
		}
		return nullptr;
	}
	

              
	private:
	// used during the registration
	AtomicSemaphore semaphore_;
	std::vector<PackMLModule*> em_;
	
	unsigned long generateId_(const char *pName)
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
              
};
     

#endif
