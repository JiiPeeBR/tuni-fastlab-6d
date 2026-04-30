
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
