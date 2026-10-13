
TYPE
	fdMove6DSyncParametersType : 	STRUCT 
		Position : McAcp6DShPositionType;
		Velocity : fdMove6DSyncAllAxesType;
		Acceleration : fdMove6DSyncAllAxesType;
		Mode : McAcp6DMoveModeEnum;
	END_STRUCT;
	fdMove6DSyncAllAxesType : 	STRUCT 
		InPlane : REAL;
		Z : REAL;
		Rx : REAL;
		Ry : REAL;
		Rz : REAL;
	END_STRUCT;
	fdMove6DSyncMemberType : 	STRUCT 
		DistanceToTarget : fdMove6DSyncAllAxesType;
		TimeToTarget : fdMove6DSyncAllAxesType;
		TimeToEndVelocity : fdMove6DSyncAllAxesType;
		LongestTimeToTarget : REAL;
		TargetVelocity : fdMove6DSyncAllAxesType;
		PositionUpdatePending : BOOL;
	END_STRUCT;
END_TYPE

TYPE
	fdMove6DParametersType : 	STRUCT 
		Position : fdMove6DParPositionType;
		Limits : fdMove6DParLimitsType;
		Velocity : fdMove6DParVelocityType;
		Mode : McAcp6DMoveModeEnum;
	END_STRUCT;
	fdMove6DParPositionType : 	STRUCT 
		X : REAL;
		Y : REAL;
		Z : REAL;
		Rx : REAL;
		Ry : REAL;
		Rz : REAL;
	END_STRUCT;
	fdMove6DParLimitsType : 	STRUCT 
		Velocity_InPlane : REAL;
		Velocity_Rx : REAL;
		Velocity_Ry : REAL;
		Velocity_Rz : REAL;
		Velocity_Z : REAL;
		Acceleration : REAL;
	END_STRUCT;
	fdMove6DParVelocityType : 	STRUCT 
		InPlane : REAL;
		Z : REAL;
		Rx : REAL;
		Ry : REAL;
		Rz : REAL;
	END_STRUCT;
END_TYPE
