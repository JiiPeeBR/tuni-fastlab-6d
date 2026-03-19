#ifndef __PACKMLMODULESHAREDINFO_HPP__
#define __PACKMLMODULESHAREDINFO_HPP__

#include "PackMLModuleEnums.hpp"

class PackMLModuleSharedInfo 
{
	public:
	// add public members and methods
	PackMLModuleSharedInfo() : 
		pName_(nullptr),
		modeCurrent_(0),
		stateCurrent_(ST_UNDEFINED),
		subStateCurrent_(0),
		stateComplete_(false),
		moduleId_(0),
		hierarchyLevel_(0)	
	{stateInfo_ = "";}
	
	const char* getName(){
		if(pName_ == nullptr)
			return "";
		return pName_;
	}
	
	const char* getStateInfo(){
		return stateInfo_.c_str();
	}
	
	
	long int getModeCurrent(){
		return modeCurrent_;
	}
	
	PackMLModuleStateEnu getStateCurrent(){
		return stateCurrent_;
	}

	long int getSubStateCurrent(){
		return subStateCurrent_;
	}
	
	bool getStateComplete(){
		return stateComplete_;
	}
	

	void setValues(const char *pName,
		long int modeCurrent,
		PackMLModuleStateEnu stateCurrent,
		long int subStateCurrent,
		bool stateComplete,
		unsigned short hierarchyLevel,
		unsigned long moduleId,
		const char *pStateInfo)
	{

		if (moduleId_ == 0) {
			moduleId_ = moduleId;
			hierarchyLevel_ = hierarchyLevel;
			
			pName_ = pName;
			modeCurrent_ = modeCurrent;
			stateCurrent_ = stateCurrent;
			subStateCurrent_ = subStateCurrent;
			stateComplete_ = stateComplete;
			stateInfo_ = pStateInfo;
			return;
		}

		// lets the module overwrite the values anyway
		if (hierarchyLevel_ < hierarchyLevel) {
			moduleId_ = moduleId;
			hierarchyLevel_ = hierarchyLevel;

			pName_ = pName;
			modeCurrent_ = modeCurrent;
			stateCurrent_ = stateCurrent;
			subStateCurrent_ = subStateCurrent;
			stateComplete_ = stateComplete;
			stateInfo_ = pStateInfo;
			return;
		}

		// Relevant for waiting for and blocked/starved
		if (moduleId_ == moduleId) {
			pName_ = pName;
			modeCurrent_ = modeCurrent;
			stateCurrent_ = stateCurrent;
			subStateCurrent_ = subStateCurrent;
			stateComplete_ = stateComplete;
			stateInfo_ = pStateInfo;
		}
	}

	// -----------------------------------------------------------------------------

	void resetValues(unsigned long moduleId)
	{
		if (moduleId_ == moduleId) {
			hierarchyLevel_ = 0;
			moduleId_ = 0;

			pName_ = nullptr;
			modeCurrent_ = 0;
			stateCurrent_ = ST_UNDEFINED;
			subStateCurrent_ = 0;
			stateComplete_ = false;
			stateInfo_ = "";
		}
	}
               
	unsigned short getHierarchyLevel(){ return hierarchyLevel_; }
              
	private:
	
	const char* pName_;
	long int modeCurrent_;
	PackMLModuleStateEnu stateCurrent_;
	long int subStateCurrent_;
	bool stateComplete_;
	std::string stateInfo_;
	
	unsigned long int moduleId_;
	unsigned short hierarchyLevel_;
	
	
              
};
     

#endif