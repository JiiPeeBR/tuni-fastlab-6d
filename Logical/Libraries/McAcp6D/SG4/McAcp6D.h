/* Automation Studio generated header file */
/* Do not edit ! */
/* McAcp6D 3.6.0 */

#ifndef _MCACP6D_
#define _MCACP6D_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _McAcp6D_VERSION
#define _McAcp6D_VERSION 3.6.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif

#ifdef _SG4
#include <McBase.h>
#endif
 
#ifdef _SG3
#include <McBase.h>
#endif
 
#ifdef _SGC
#include <McBase.h>
#endif

/* Datatypes and datatypes of function blocks */
typedef enum McAcp6DControllerStateEnum
{	mcACP6D_STATE_BOOTING = 0,
	mcACP6D_STATE_INACTIVE = 1,
	mcACP6D_STATE_ACTIVATING = 2,
	mcACP6D_STATE_DISCOVERY = 3,
	mcACP6D_STATE_SERVICE = 4,
	mcACP6D_STATE_OPERATION = 5,
	mcACP6D_STATE_DEACTIVATING = 7,
	mcACP6D_STATE_ERROR_HANDLING = 8,
	mcACP6D_STATE_ERROR = 9
} McAcp6DControllerStateEnum;

typedef enum McAcp6DShStereotypeDeleteCmdEnum
{	mcACP6D_SH_ST_DELETE_SPECIFIC = 0,
	mcACP6D_SH_ST_DELETE_ALL = 1
} McAcp6DShStereotypeDeleteCmdEnum;

typedef enum McAcp6DShGetInfoOptionEnum
{	mcACP6D_POSITION_FEEDBACK = 0,
	mcACP6D_FORCE_FEEDBACK = 1
} McAcp6DShGetInfoOptionEnum;

typedef enum McAcp6DMacroDeleteCmdEnum
{	mcACP6D_MACRO_DELETE_SPECIFIC = 0,
	mcACP6D_MACRO_DELETE_ALL = 1
} McAcp6DMacroDeleteCmdEnum;

typedef enum McAcp6dPLCopenStateEnum
{	mcACP6D_DISABLED = 0,
	mcACP6D_HOMING = 1,
	mcACP6D_READY = 2,
	mcACP6D_STOPPING = 3,
	mcACP6D_ERRORSTOP = 4,
	mcACP6D_STARTUP = 5,
	mcACP6D_INVALID_CONFIGURATION = 6
} McAcp6dPLCopenStateEnum;

typedef enum McAcp6DShStateEnum
{	mcACP6D_SH_STATE_UNDETECTED = 0,
	mcACP6D_SH_STATE_DISCOVERING = 1,
	mcACP6D_SH_STATE_LANDED = 2,
	mcACP6D_SH_STATE_IDLING = 3,
	mcACP6D_SH_STATE_DISABLED = 4,
	mcACP6D_SH_STATE_MOTION = 5,
	mcACP6D_SH_STATE_WAIT = 6,
	mcACP6D_SH_STATE_STOPPING = 7,
	mcACP6D_SH_STATE_OBSTACLE = 8,
	mcACP6D_SH_STATE_HOLD = 9,
	mcACP6D_SH_STATE_STOPPED = 10,
	mcACP6D_SH_STATE_ERROR = 14,
	mcACP6D_SH_STATE_RESERVED = 15
} McAcp6DShStateEnum;

typedef enum McAcp6DZoneStateEnum
{	mcACP6D_ZONE_NOT_AVAILABLE = 0,
	mcACP6D_ZONE_ACTIVE_OPEN = 1,
	mcACP6D_ZONE_DEACTIVATING = 2,
	mcACP6D_ZONE_LOADING = 3,
	mcACP6D_ZONE_ACTIVATING = 4,
	mcACP6D_ZONE_ACTIVE_CLOSED = 5,
	mcACP6D_ZONE_ERROR = 6
} McAcp6DZoneStateEnum;

typedef enum McAcp6DAutoZoneCtrlCmdEnum
{	mcACP6D_AUTO_ZONE_CREATE = 0,
	mcACP6D_AUTO_ZONE_DELETE = 1,
	mcACP6D_AUTO_ZONE_ACTIVATE = 2,
	mcACP6D_AUTO_ZONE_DEACTIVATE = 3
} McAcp6DAutoZoneCtrlCmdEnum;

typedef enum McAcp6DAutoZoneStateEnum
{	mcACP6D_AUTO_ZONE_UNDEFINED = 0,
	mcACP6D_AUTO_ZONE_DEFINED = 1,
	mcACP6D_AUTO_ZONE_UNLOADING_ZONE = 2,
	mcACP6D_AUTO_ZONE_LOADING_ZONE = 3
} McAcp6DAutoZoneStateEnum;

typedef enum McAcp6DAutoZoneOpStateEnum
{	mcACP6D_AUTO_ZONE_BUSY = 0,
	mcACP6D_AUTO_ZONE_READY = 1
} McAcp6DAutoZoneOpStateEnum;

typedef enum McAcp6DSegTypesEnum
{	mcACP6D_SEG_TYPE_240_240 = 0,
	mcACP6D_SEG_TYPE_480_120 = 1,
	mcACP6D_SEG_TYPE_120_480 = 2,
	mcACP6D_SEG_TYPE_320_320 = 3,
	mcACP6D_SEG_TYPE_640_160 = 4,
	mcACP6D_SEG_TYPE_160_640 = 5
} McAcp6DSegTypesEnum;

typedef enum McAcp6DPlanetCtrlOptionEnum
{	mcACP6D_PLANET_REMOVE_SH = 0,
	mcACP6D_PLANET_ADD_SH = 1
} McAcp6DPlanetCtrlOptionEnum;

typedef enum McAcp6DShGroupCoupleStateEnum
{	mcACP6D_SH_GROUP_DECOUPLED = 0,
	mcACP6D_SH_GROUP_COUPLED = 1
} McAcp6DShGroupCoupleStateEnum;

typedef enum McAcp6DShGroupCoupleOptionEnum
{	mcACP6D_SH_GROUP_DECOUPLE = 0,
	mcACP6D_SH_GROUP_COUPLE = 1
} McAcp6DShGroupCoupleOptionEnum;

typedef enum McAcp6DShGroupCoupleModeEnum
{	mcACP6D_SH_GROUP_INDV_ROT_REF = 0,
	mcACP6D_SH_GROUP_CMN_ROT_REF = 1
} McAcp6DShGroupCoupleModeEnum;

typedef enum McAcp6DZoneTypeEnum
{	mcACP6D_ZONE_TYPE_NORMAL = 0,
	mcACP6D_ZONE_TYPE_KEEP_OUT = 1,
	mcACP6D_ZONE_TYPE_INTERSECTION = 2
} McAcp6DZoneTypeEnum;

typedef enum McAcp6DForceModeOptionEnum
{	mcACP6D_FORCE_MODE_EXIT = 0,
	mcACP6D_FORCE_MODE_Z = 1,
	mcACP6D_FORCE_MODE_X = 2,
	mcACP6D_FORCE_MODE_Y = 3,
	mcACP6D_FORCE_MODE_XY = 4,
	mcACP6D_FORCE_MODE_RZ = 5,
	mcACP6D_FORCE_MODE_RZX = 8,
	mcACP6D_FORCE_MODE_RZY = 9,
	mcACP6D_FORCE_MODE_RZXY = 11
} McAcp6DForceModeOptionEnum;

typedef enum McAcp6DZoneOverrideModeEnum
{	mcACP6D_ZONE_OVERRIDE_FACTOR = 0,
	mcACP6D_ZONE_OVERRIDE_ABSOLUTE = 1
} McAcp6DZoneOverrideModeEnum;

typedef enum McAcp6DMoveModeEnum
{	mcACP6D_MOVE_ABSOLUTE = 0,
	mcACP6D_MOVE_RELATIVE = 1
} McAcp6DMoveModeEnum;

typedef enum McAcp6DInPlanePathEnum
{	mcACP6D_PATH_DIRECT = 0,
	mcACP6D_PATH_X_THEN_Y = 1,
	mcACP6D_PATH_Y_THEN_X = 2
} McAcp6DInPlanePathEnum;

typedef enum McAcp6DArcDirectionEnum
{	mcACP6D_ARC_CLOCKWISE = 0,
	mcACP6D_ARC_COUNTER_CLOCKWISE = 1
} McAcp6DArcDirectionEnum;

typedef enum McAcp6DArcOptionEnum
{	mcACP6D_ARC_RADIUS = 0,
	mcACP6D_ARC_ANGULAR = 1
} McAcp6DArcOptionEnum;

typedef enum McAcp6DArcTypeEnum
{	mcACP6D_ARC_MINOR,
	mcACP6D_ARC_MAJOR
} McAcp6DArcTypeEnum;

typedef enum McAcp6DShortAxRotEnum
{	mcACP6D_SHORT_AX_ROT_ONLY,
	mcACP6D_SHORT_AX_ROT_CENTER
} McAcp6DShortAxRotEnum;

typedef enum McAcp6DLevitationLevelEnum
{	mcACP6D_LEVEL_LAND = 0,
	mcACP6D_LEVEL_LEVITATE = 1
} McAcp6DLevitationLevelEnum;

typedef enum McAcp6DBufferStateEnum
{	mcACP6D_BUFFER_STATE_BLOCKED = 0,
	mcACP6D_BUFFER_STATE_OPEN = 1
} McAcp6DBufferStateEnum;

typedef enum McAcp6DHaltOptionEnum
{	mcACP6D_CONTINUE = 0,
	mcACP6D_HALT = 1
} McAcp6DHaltOptionEnum;

typedef enum McAcp6DGetPayloadModeEnum
{	mcACP6D_PAYLOAD_DIRECT = 0,
	mcACP6D_PAYLOAD_DURATION = 1,
	mcACP6D_PAYLOAD_DURATION_ASYNC = 2
} McAcp6DGetPayloadModeEnum;

typedef enum McAcp6DAsmBufferOptionEnum
{	mcACP6D_BUFFER_ASM_BLOCK = 0,
	mcACP6D_BUFFER_ASM_RELEASE = 1,
	mcACP6D_BUFFER_ASM_CLEAR = 2
} McAcp6DAsmBufferOptionEnum;

typedef enum McAcp6DShGroupBufferOptionEnum
{	mcACP6D_BUFFER_SHGROUP_BLOCK = 0,
	mcACP6D_BUFFER_SHGROUP_RELEASE = 1
} McAcp6DShGroupBufferOptionEnum;

typedef enum McAcp6DBufferOptionEnum
{	mcACP6D_BUFFER_BLOCK = 0,
	mcACP6D_BUFFER_RELEASE = 1,
	mcACP6D_BUFFER_CLEAR = 2,
	mcACP6D_BUFFER_GET_STATUS = 3
} McAcp6DBufferOptionEnum;

typedef enum McAcp6DBarrierCmdEnum
{	mcACP6D_BARRIER_OPEN = 0,
	mcACP6D_BARRIER_CLOSE = 1
} McAcp6DBarrierCmdEnum;

typedef enum McAcp6DValueSrcEnum
{	mcACP6D_VALUE_ACTUAL = 0
} McAcp6DValueSrcEnum;

typedef enum McAcp6DShTypesEnum
{	mcACP6D_SH_TYPE_120_120 = 0,
	mcACP6D_SH_TYPE_180_120 = 2,
	mcACP6D_SH_TYPE_120_180 = 3,
	mcACP6D_SH_TYPE_240_120 = 4,
	mcACP6D_SH_TYPE_180_180 = 6,
	mcACP6D_SH_TYPE_210_180 = 8,
	mcACP6D_SH_TYPE_180_210 = 9,
	mcACP6D_SH_TYPE_210_210 = 12,
	mcACP6D_SH_TYPE_240_240 = 14,
	mcACP6D_SH_TYPE_330_210 = 16,
	mcACP6D_SH_TYPE_300_300 = 18,
	mcACP6D_SH_TYPE_330_330 = 20,
	mcACP6D_SH_TYPE_450_450 = 22,
	mcACP6D_SH_TYPE_S4_160_160 = 30,
	mcACP6D_SH_TYPE_S4_160_240 = 32,
	mcACP6D_SH_TYPE_S4_160_320 = 34,
	mcACP6D_SH_TYPE_S4_240_240 = 36,
	mcACP6D_SH_TYPE_S4_240_280 = 38,
	mcACP6D_SH_TYPE_S4_280_280 = 42,
	mcACP6D_SH_TYPE_S4_320_320 = 44,
	mcACP6D_SH_TYPE_S4_280_440 = 46,
	mcACP6D_SH_TYPE_S4_400_400 = 48,
	mcACP6D_SH_TYPE_S4_440_440 = 50,
	mcACP6D_SH_TYPE_S4_600_600 = 52,
	mcACP6D_SH_TYPE_ANY = 99
} McAcp6DShTypesEnum;

typedef enum McAcp6DShPerformanceLevelEnum
{	mcACP6D_SH_PERF_STABILITY = 0,
	mcACP6D_SH_PERF_SEMI_STABILITY = 1,
	mcACP6D_SH_PERF_SEMI_AGGRESSIVE = 2,
	mcACP6D_SH_PERF_AGGRESSIVE = 3
} McAcp6DShPerformanceLevelEnum;

typedef enum McAcp6DShStereotypeTypeEnum
{	mcACP6D_SH_STEREOTYPE_CUSTOM = 0,
	mcACP6D_SH_STEREOTYPE_DEFAULT = 1
} McAcp6DShStereotypeTypeEnum;

typedef enum McAcp6DShWaitFBDITriggerEnum
{	mcACP6D_SH_WAIT_FBDI_RE = 0,
	mcACP6D_SH_WAIT_FBDI_FE = 1,
	mcACP6D_SH_WAIT_FBDI_HL = 2,
	mcACP6D_SH_WAIT_FBDI_LL = 3
} McAcp6DShWaitFBDITriggerEnum;

typedef enum McAcp6DShWaitZoneTriggerEnum
{	mcACP6D_SH_WAIT_ZONE_RE = 0,
	mcACP6D_SH_WAIT_ZONE_FE = 1,
	mcACP6D_SH_WAIT_ZONE_GT = 2,
	mcACP6D_SH_WAIT_ZONE_LT = 3
} McAcp6DShWaitZoneTriggerEnum;

typedef enum McAcp6DRotaryMotionModeEnum
{	mcACP6D_ROTATE_ABSOLUTE_POS = 0,
	mcACP6D_ROTATE_COUNTER_CLOCKWISE = 1,
	mcACP6D_ROTATE_CLOCKWISE = 2
} McAcp6DRotaryMotionModeEnum;

typedef enum McAcp6DShWaitCmdLbTriggerEnum
{	mcACP6D_SH_WAIT_CMDLB_START = 0,
	mcACP6D_SH_WAIT_CMDLB_END = 1,
	mcACP6D_SH_WAIT_CMDLB_ANY = 2
} McAcp6DShWaitCmdLbTriggerEnum;

typedef enum McAcp6DShWaitCmdLbLabelEnum
{	mcACP6D_SH_WAIT_CMDLB_REGULAR = 0,
	mcACP6D_SH_WAIT_CMDLB_MACRO = 1
} McAcp6DShWaitCmdLbLabelEnum;

typedef enum McAcp6DShWaitDispModeEnum
{	mcACP6D_SH_WAIT_DISP_X_ONLY = 0,
	mcACP6D_SH_WAIT_DISP_Y_ONLY = 1,
	mcACP6D_SH_WAIT_DISP_STRLINE = 2
} McAcp6DShWaitDispModeEnum;

typedef enum McAcp6DShWaitDispTypeEnum
{	mcACP6D_SH_WAIT_DISP_GT = 0,
	mcACP6D_SH_WAIT_DISP_LT = 1,
	mcACP6D_SH_WAIT_DISP_RE = 2,
	mcACP6D_SH_WAIT_DISP_FE = 3
} McAcp6DShWaitDispTypeEnum;

typedef enum McAcp6PowerSecStateEnum
{	mcACP6D_POWER_SEC_UNDEFINED = 0,
	mcACP6D_POWER_SEC_DISCONNECTED = 1,
	mcACP6D_POWER_SEC_INACTIVE_CLOSE = 2,
	mcACP6D_POWER_SEC_DEACTIVATING = 3,
	mcACP6D_POWER_SEC_ACTIVATING = 5,
	mcACP6D_POWER_SEC_ACTIVE_CLOSE = 6,
	mcACP6D_POWER_SEC_OPERATION = 7
} McAcp6PowerSecStateEnum;

typedef enum McAcp6DAxisEnum
{	mcACP6D_AXIS_X = 1,
	mcACP6D_AXIS_Y = 2,
	mcACP6D_AXIS_Z = 3,
	mcACP6D_AXIS_Rx = 4,
	mcACP6D_AXIS_Ry = 5,
	mcACP6D_AXIS_Rz = 6
} McAcp6DAxisEnum;

typedef enum McAcp6DShRecovBufferOptEnum
{	mcACP6D_SH_RECOV_BUFFER_RESUME = 0,
	mcACP6D_SH_RECOV_BUFFER_PAUSE = 1,
	mcACP6D_SH_RECOV_BUFFER_CLEAR = 2
} McAcp6DShRecovBufferOptEnum;

typedef enum McAcp6DShRecovShortAxesOptEnum
{	mcACP6D_SH_RECOV_SHORTAX_DEF = 0,
	mcACP6D_SH_RECOV_SHORTAX_PREV = 1
} McAcp6DShRecovShortAxesOptEnum;

typedef enum McAcp6DMoveInPlaneAsyncModeEnum
{	mcACP6D_SHUTTLE_SORTED = 0,
	mcACP6D_SHUTTLE_UNSORTED = 1
} McAcp6DMoveInPlaneAsyncModeEnum;

typedef enum McAcp6DAsmActivationOptionEnum
{	mcACP6D_ASMPOWERON_AUTO = 0,
	mcACP6D_ASMPOWERON_TO_LANDED = 1,
	mcACP6D_ASMPOWERON_TO_LEVITATION = 2,
	mcACP6D_ASMPOWERON_TO_IDENT = 3,
	mcACP6D_ASMPOWERON_TO_READY = 4
} McAcp6DAsmActivationOptionEnum;

typedef enum McAcp6DAutoZoneLoadingStatusEnum
{	mcACP6D_AUTO_ZONE_LOAD_NO_ERROR = 0,
	mcACP6D_AUTO_ZONE_LOAD_ERROR = 2
} McAcp6DAutoZoneLoadingStatusEnum;

typedef enum McAcp6DAsmBorderStateEnum
{	mcACP6D_BORDER_INACTIVE = 0,
	mcACP6D_BORDER_NOT_READY = 1,
	mcACP6D_BORDER_READY = 2
} McAcp6DAsmBorderStateEnum;

typedef enum McAcp6DStatus6DLinkEnum
{	mcACP6D_6DLINK_CONNECTED = 0,
	mcACP6D_6DLINK_DISCONNECTED = 1
} McAcp6DStatus6DLinkEnum;

typedef enum McAcp6DStatusPowerlinkEnum
{	mcACP6D_PLK_CONNECTED_SYNC = 0,
	mcACP6D_PLK_DISCONNECTED = 1,
	mcACP6D_PLK_CONNECTED_NOT_SYNC = 2
} McAcp6DStatusPowerlinkEnum;

typedef enum McAcp6DStatusShuttleHomingEnum
{	mcACP6D_SH_HOMING_INPROGRESS = 0,
	mcACP6D_SH_HOMING_DONE = 1
} McAcp6DStatusShuttleHomingEnum;

typedef enum McAcp6DUserDataModeEnum
{	mcACP6D_USERDATA_GET = 0,
	mcACP6D_USERDATA_SET = 1
} McAcp6DUserDataModeEnum;

typedef enum McAcp6DAsmConfigHandlerModeEnum
{	mcACP6D_ASM_LOAD_CONFIG = 0,
	mcACP6D_ASM_SAVE_PARAM = 1
} McAcp6DAsmConfigHandlerModeEnum;

typedef enum McAcp6DAsmParamModeEnum
{	mcACP6D_ASMPARA_READ = 0,
	mcACP6D_ASMPARA_WRITE = 1
} McAcp6DAsmParamModeEnum;

typedef enum McAcp6DAssemblySegSimCfgEnum
{	mcACP6D_SEG_SIM_OFF = 0,
	mcACP6D_SEG_SIM_ON = 1
} McAcp6DAssemblySegSimCfgEnum;

typedef enum McAcp6DAsmShuttleIDModeCfgEnum
{	mcACP6D_REAL_TIME_ID = 0,
	mcACP6D_ABS_ID_NO_ORIENTATION = 1,
	mcACP6D_ABS_ID_ORIENTATION = 2
} McAcp6DAsmShuttleIDModeCfgEnum;

typedef enum McAcp6DLayoutGridSizeCfgEnum
{	mcACP6D_GRID_SIZE_S3_240_MM = 0,
	mcACP6D_GRID_SIZE_S3_120_MM = 1,
	mcACP6D_GRID_SIZE_S4_320_MM = 2,
	mcACP6D_GRID_SIZE_S4_160_MM = 3
} McAcp6DLayoutGridSizeCfgEnum;

typedef enum McAcp6DAsmSyncTypeCfgEnum
{	mcACP6D_ASM_SYNC_NOT_USED = 0,
	mcACP6D_ASM_SYNC_USED = 1
} McAcp6DAsmSyncTypeCfgEnum;

typedef enum McAcp6DAsmSyncEdgeCfgEnum
{	mcACP6D_ASM_SYNC_EDGE_TOP = 0,
	mcACP6D_ASM_SYNC_EDGE_RIGHT = 1,
	mcACP6D_ASM_SYNC_EDGE_BOTTOM = 2,
	mcACP6D_ASM_SYNC_EDGE_LEFT = 3
} McAcp6DAsmSyncEdgeCfgEnum;

typedef enum McAcp6DSegmentTypeEnum
{	mcACP6D_SEG_S3_AS = 0,
	mcACP6D_SEG_S3_AN_X = 1,
	mcACP6D_SEG_S3_AN_Y = 2,
	mcACP6D_SEG_S4_AS = 3
} McAcp6DSegmentTypeEnum;

typedef enum McAcp6DSegmentGapSizeEnum
{	mcACP6D_SEG_GAP_S3_0 = 0,
	mcACP6D_SEG_GAP_S3_5 = 1,
	mcACP6D_SEG_GAP_S3_10 = 2,
	mcACP6D_SEG_GAP_S3_20 = 3,
	mcACP6D_SEG_GAP_S3_60 = 4,
	mcACP6D_SEG_GAP_S4_0 = 5,
	mcACP6D_SEG_GAP_S4_6_66 = 6,
	mcACP6D_SEG_GAP_S4_13_33 = 7,
	mcACP6D_SEG_GAP_S4_26_66 = 8
} McAcp6DSegmentGapSizeEnum;

typedef enum McAcp6DSegmentGapSizeCfgEnum
{	mcACP6D_SEG_BORDER_ID_0 = 0,
	mcACP6D_SEG_BORDER_ID_1 = 1,
	mcACP6D_SEG_BORDER_ID_2 = 2,
	mcACP6D_SEG_BORDER_ID_3 = 3,
	mcACP6D_SEG_BORDER_ID_4 = 4
} McAcp6DSegmentGapSizeCfgEnum;

typedef enum McAcp6DAsmCommLossReactionEnum
{	mcACP6D_COMM_LOSS_CONTINUE = 0,
	mcACP6D_COMM_LOSS_STOP = 2,
	mcACP6D_COMM_LOSS_POWER_OFF = 3
} McAcp6DAsmCommLossReactionEnum;

typedef struct Mc6DAssemblyType
{	struct Mc6DInternalAssemblyIfType* controlif;
} Mc6DAssemblyType;

typedef struct Mc6DInternalAssemblyIfType
{	plcdword vtable;
} Mc6DInternalAssemblyIfType;

typedef struct Mc6DShuttleType
{	struct Mc6DInternalShuttleIfType* controlif;
} Mc6DShuttleType;

typedef struct Mc6DShuttleGroupType
{	struct Mc6DInternalShuttleGroupIfType* controlif;
} Mc6DShuttleGroupType;

typedef struct Mc6DSegmentType
{	struct Mc6DInternalSegmentIfType* controlif;
} Mc6DSegmentType;

typedef struct Mc6DZoneType
{	struct Mc6DInternalZoneIfType* controlif;
} Mc6DZoneType;

typedef struct Mc6DInternalZoneIfType
{	plcdword vtable;
} Mc6DInternalZoneIfType;

typedef struct Mc6DInternalSegmentIfType
{	plcdword vtable;
} Mc6DInternalSegmentIfType;

typedef struct Mc6DInternalShuttleIfType
{	plcdword vtable;
} Mc6DInternalShuttleIfType;

typedef struct Mc6DInternalShuttleGroupIfType
{	plcdword vtable;
} Mc6DInternalShuttleGroupIfType;

typedef struct Mc6DControllerFBIOType
{	unsigned short Array[200];
} Mc6DControllerFBIOType;

typedef struct McAcp6DAutoZoneInfoTyp
{	enum McAcp6DAutoZoneStateEnum ZoneState;
	enum McAcp6DAutoZoneOpStateEnum EntranceExitState;
	unsigned char numShuttles;
	struct Mc6DShuttleType Shuttle;
	float ZoneX;
	float ZoneY;
} McAcp6DAutoZoneInfoTyp;

typedef struct McAcp6DAutoZoneCtrlParType
{	unsigned char ZoneMode;
	unsigned char UnloadingMode;
	unsigned char LoadingDirection;
	unsigned char LoadFailResetMode;
	float ZoneCenterX;
	float ZoneCenterY;
	float ZoneLength;
	float ZoneWidth;
	float MaxShuttleSizeX;
	float MaxShuttleSizeY;
	float Velocity;
	float Acceleration;
	float MaxHeight;
} McAcp6DAutoZoneCtrlParType;

typedef struct McAcp6DJogVelocityParType
{	plcbit Jog;
	float Direction;
	float Velocity;
} McAcp6DJogVelocityParType;

typedef struct McAcp6DAsmInfoType
{	enum McAcp6dPLCopenStateEnum AssemblyState;
	enum McAcp6DControllerStateEnum Controller6DState;
	unsigned char ShuttlesInAccidentCount;
	unsigned char ShuttlesCount;
	plcbit CommunicationReady;
} McAcp6DAsmInfoType;

typedef struct McAcp6DAsmGetInfoType
{	enum McAcp6DControllerStateEnum State;
	unsigned short NumberOfShuttles;
	float Power;
	float MaxCPUTemp;
	float MaxAmplifierTemp;
	float MaxMotorTemp;
	enum McAcp6DStatusPowerlinkEnum StatusPowerlink;
	enum McAcp6DStatus6DLinkEnum Status6DLink;
	enum McAcp6DStatusShuttleHomingEnum StatusShuttleHoming;
	unsigned long ErrorCode;
} McAcp6DAsmGetInfoType;

typedef struct McAcp6DSerialNumType
{	unsigned long SerialNumHigh;
	unsigned long SerialNumLow;
} McAcp6DSerialNumType;

typedef struct McAcp6DVersionNumType
{	unsigned long VersionNumHigh;
	unsigned long VersionNumLow;
} McAcp6DVersionNumType;

typedef struct McAcp6DSegPositionType
{	float X;
	float Y;
} McAcp6DSegPositionType;

typedef struct McAcp6DSegInfoType
{	float Power;
	float CPUTemp;
	float AmplifierTemp;
	float MotorTemp;
	struct McAcp6DSegPositionType Position;
	enum McAcp6DSegTypesEnum Type;
} McAcp6DSegInfoType;

typedef struct McAcp6DAsyncPosType
{	float X;
	float Y;
	struct Mc6DShuttleType* Shuttle;
} McAcp6DAsyncPosType;

typedef struct McAcp6DMoveInPlaneAsyncParType
{	float Velocity;
	float Acceleration;
	struct McAcp6DAsyncPosType AsyncPar[78];
	struct Mc6DZoneType* Zone;
	enum McAcp6DMoveInPlaneAsyncModeEnum Mode;
	plcbit MoveOnlySelectedShuttles;
	plcbit Overhang;
} McAcp6DMoveInPlaneAsyncParType;

typedef struct McAcp6DShGroupShListParType
{	struct Mc6DShuttleType* Shuttle;
} McAcp6DShGroupShListParType;

typedef struct McAcp6DShGroupAddShParType
{	struct McAcp6DShGroupShListParType ShuttleList[32];
} McAcp6DShGroupAddShParType;

typedef struct McAcp6DPlanetParType
{	enum McAcp6DPlanetCtrlOptionEnum Option;
	struct McAcp6DShGroupShListParType ShuttleList[32];
} McAcp6DPlanetParType;

typedef struct McAcp6DShGroupCoupleCtrlParType
{	enum McAcp6DShGroupCoupleModeEnum Mode;
	enum McAcp6DShGroupCoupleOptionEnum Option;
} McAcp6DShGroupCoupleCtrlParType;

typedef struct McAcp6DShGroupInfoType
{	enum McAcp6DShGroupCoupleStateEnum CoupleState;
	unsigned short NumberOfShuttles;
} McAcp6DShGroupInfoType;

typedef struct McAcp6DSegBarrierInfoType
{	enum McAcp6DZoneStateEnum State;
	unsigned short NumberOfShuttles;
} McAcp6DSegBarrierInfoType;

typedef struct McAcp6DZoneBarrierInfoType
{	enum McAcp6DZoneStateEnum State;
	unsigned short NumberOfShuttles;
} McAcp6DZoneBarrierInfoType;

typedef struct McAcp6DInPlaneAxesType
{	float X;
	float Y;
} McAcp6DInPlaneAxesType;

typedef struct McAcp6DCreateZoneParType
{	plcstring Name[33];
	enum McAcp6DZoneTypeEnum ZoneType;
	unsigned short MaxShuttleCount;
	plcbit ActivateLevitationLimit;
	float LevitationLimit;
	struct McAcp6DInPlaneAxesType BottomLeft;
	struct McAcp6DInPlaneAxesType TopRight;
} McAcp6DCreateZoneParType;

typedef struct McAcp6DZoneOverrideParType
{	enum McAcp6DZoneOverrideModeEnum Mode;
	float MaxVelocity;
	float MaxAcceleration;
} McAcp6DZoneOverrideParType;

typedef struct McAcp6DGetShAddInfoType
{	unsigned short ShuttleID;
} McAcp6DGetShAddInfoType;

typedef struct McAcp6DGetSegAddInfoType
{	unsigned short SegmentID;
} McAcp6DGetSegAddInfoType;

typedef struct McAcp6DGetZoneAddInfoType
{	unsigned short ZoneID;
	enum McAcp6DZoneTypeEnum ZoneType;
	plcstring Name[33];
} McAcp6DGetZoneAddInfoType;

typedef struct McAcp6DGetShGroupAddInfoType
{	unsigned short GroupID;
} McAcp6DGetShGroupAddInfoType;

typedef struct McAcp6DBarrierCmdParType
{	enum McAcp6DBarrierCmdEnum Command;
} McAcp6DBarrierCmdParType;

typedef struct McAcp6DShortAxAxesType
{	float Z;
	float Rx;
	float Ry;
	float Rz;
} McAcp6DShortAxAxesType;

typedef struct McAcp6DInPlaneParType
{	struct McAcp6DInPlaneAxesType Position;
	float Velocity;
	float EndVelocity;
	float Acceleration;
	float Radius;
	enum McAcp6DMoveModeEnum Mode;
	enum McAcp6DInPlanePathEnum Path;
} McAcp6DInPlaneParType;

typedef struct McAcp6DAxisBoolType
{	plcbit X;
	plcbit Y;
	plcbit Z;
	plcbit RX;
	plcbit RY;
	plcbit RZ;
} McAcp6DAxisBoolType;

typedef struct McAcp6DMoveCyclicParType
{	struct McAcp6DAxisBoolType DisableAxis;
} McAcp6DMoveCyclicParType;

typedef struct McAcp6DReadCyclicParType
{	enum McAcp6DValueSrcEnum ValueSource;
} McAcp6DReadCyclicParType;

typedef struct McAcp6DShortAxRotType
{	enum McAcp6DShortAxRotEnum Type;
	struct McAcp6DInPlaneAxesType Center;
} McAcp6DShortAxRotType;

typedef struct McAcp6DShortAxParType
{	struct McAcp6DShortAxAxesType Position;
	struct McAcp6DShortAxAxesType Velocity;
	enum McAcp6DMoveModeEnum Mode;
	struct McAcp6DShortAxRotType Rotation;
} McAcp6DShortAxParType;

typedef struct McAcp6DArcAngularType
{	struct McAcp6DInPlaneAxesType Center;
	float Angle;
} McAcp6DArcAngularType;

typedef struct McAcp6DArcRadiusType
{	struct McAcp6DInPlaneAxesType Position;
	float Radius;
	enum McAcp6DArcTypeEnum ArcType;
} McAcp6DArcRadiusType;

typedef struct McAcp6DArcParType
{	enum McAcp6DArcDirectionEnum Direction;
	float Velocity;
	float EndVelocity;
	float Acceleration;
	enum McAcp6DMoveModeEnum Mode;
	enum McAcp6DArcOptionEnum Option;
	struct McAcp6DArcAngularType Angular;
	struct McAcp6DArcRadiusType Radius;
} McAcp6DArcParType;

typedef struct McAcp6DLevitationParType
{	enum McAcp6DLevitationLevelEnum Level;
	unsigned char Speed;
	float ZForce;
} McAcp6DLevitationParType;

typedef struct McAcp6DShortAx6DParType
{	struct McAcp6DShortAxAxesType Position;
	struct McAcp6DShortAxAxesType Velocity;
} McAcp6DShortAx6DParType;

typedef struct McAcp6DInPlane6DParType
{	struct McAcp6DInPlaneAxesType Position;
	float Velocity;
	float Acceleration;
} McAcp6DInPlane6DParType;

typedef struct McAcp6DMove6DParType
{	struct McAcp6DInPlane6DParType InPlane;
	struct McAcp6DShortAx6DParType ShortAxis;
} McAcp6DMove6DParType;

typedef struct McAcp6DShPositionType
{	float X;
	float Y;
	float Z;
	float Rx;
	float Ry;
	float Rz;
} McAcp6DShPositionType;

typedef struct McAcp6DShForceType
{	float Fx;
	float Fy;
	float Fz;
	float Tx;
	float Ty;
	float Tz;
} McAcp6DShForceType;

typedef struct McAcp6DForceModeParType
{	enum McAcp6DForceModeOptionEnum Option;
	struct McAcp6DShForceType Force;
} McAcp6DForceModeParType;

typedef struct McAcp6DShInfoMotionBufferType
{	unsigned short NumberOfCommands;
	plcbit IsBlocked;
	unsigned short CommandLabel;
} McAcp6DShInfoMotionBufferType;

typedef struct McAcp6DShInfoType
{	unsigned short ShuttleID;
	enum McAcp6DShStateEnum State;
	struct McAcp6DShPositionType Position;
	plcbit Discovered;
} McAcp6DShInfoType;

typedef struct McAcp6DShGetInfoType
{	unsigned short ShuttleID;
	enum McAcp6DShStateEnum State;
	struct McAcp6DShPositionType Position;
	struct McAcp6DShForceType Force;
	plcbit IsHalt;
	struct McAcp6DShInfoMotionBufferType MotionBuffer;
	struct McAcp6DAxisBoolType ForceMode;
	struct Mc6DShuttleType StarShuttle;
} McAcp6DShGetInfoType;

typedef struct McAcp6DShGetPropertyType
{	enum McAcp6DShTypesEnum ShuttleType;
} McAcp6DShGetPropertyType;

typedef struct McAcp6DBufferInfoType
{	unsigned short NumberOfCommands;
	enum McAcp6DBufferStateEnum State;
	unsigned short NextCmdLabel;
	unsigned short LatestCmdLabel;
} McAcp6DBufferInfoType;

typedef struct McAcp6DErrInfoType
{	unsigned char NumberOfErrors;
	signed long ErrorCode[9];
} McAcp6DErrInfoType;

typedef struct McAcp6DPayloadSizeType
{	float XOffsetPos;
	float XOffsetNeg;
	float YOffsetPos;
	float YOffsetNeg;
} McAcp6DPayloadSizeType;

typedef struct McAcp6DCoGType
{	float X;
	float Y;
	float Z;
} McAcp6DCoGType;

typedef struct McAcp6DShStereotypeParType
{	plcstring Name[33];
	enum McAcp6DShTypesEnum ShuttleType;
	enum McAcp6DShStereotypeTypeEnum Type;
	enum McAcp6DShPerformanceLevelEnum PerformanceLevel;
	float Payload;
	struct McAcp6DPayloadSizeType PayloadSize;
	struct McAcp6DCoGType CenterOfGravity;
	float Deceleration;
} McAcp6DShStereotypeParType;

typedef struct McAcp6DStereotypeGetInfoType
{	enum McAcp6DShTypesEnum ShuttleType;
	enum McAcp6DShPerformanceLevelEnum PerformanceLevel;
	float Payload;
	struct McAcp6DPayloadSizeType PayloadSize;
	struct McAcp6DCoGType CenterOfGravity;
	float Deceleration;
} McAcp6DStereotypeGetInfoType;

typedef struct McAcp6DMacroCreateParType
{	plcstring Name[33];
} McAcp6DMacroCreateParType;

typedef struct McAcp6DRotaryMotionParType
{	enum McAcp6DRotaryMotionModeEnum Mode;
	float Angle;
	float Velocity;
	float Acceleration;
} McAcp6DRotaryMotionParType;

typedef struct McAcp6DRotaryMotionSpinParType
{	float Duration;
	float Angle;
	float Velocity;
	float Acceleration;
} McAcp6DRotaryMotionSpinParType;

typedef struct Mc6DPowerSecType
{	struct Mc6DInternalPowerSecIfType* controlif;
} Mc6DPowerSecType;

typedef struct Mc6DInternalPowerSecIfType
{	plcdword vtable;
} Mc6DInternalPowerSecIfType;

typedef struct McAcp6DGetPowerSecAddInfoType
{	unsigned short SectorID;
	plcstring Name[33];
} McAcp6DGetPowerSecAddInfoType;

typedef struct McAcp6DPowerSecInfoType
{	plcstring Name[33];
	unsigned short SectorID;
	enum McAcp6PowerSecStateEnum State;
} McAcp6DPowerSecInfoType;

typedef struct McAcp6DSetJerkLimitParType
{	enum McAcp6DAxisEnum Axis;
	float JerkLimit;
} McAcp6DSetJerkLimitParType;

typedef struct McAcp6DAutoZoneStateType
{	unsigned char ZoneID;
	enum McAcp6DAutoZoneStateEnum ZoneState;
	enum McAcp6DAutoZoneOpStateEnum EntranceExitState;
	struct Mc6DShuttleType Shuttle;
	enum McAcp6DAutoZoneLoadingStatusEnum LastLoadingStatus;
} McAcp6DAutoZoneStateType;

typedef struct McAcp6DAutoZoneAllInfoType
{	unsigned short NumberOfZones;
	struct McAcp6DAutoZoneStateType AutoZoneStatusPar[40];
} McAcp6DAutoZoneAllInfoType;

typedef struct McAcp6DReadArrivedShAddInfoType
{	unsigned short ShuttleID;
	unsigned short BorderID;
} McAcp6DReadArrivedShAddInfoType;

typedef struct McAcp6DChangeShIDParType
{	unsigned char NumberOfShuttles;
	unsigned char CurrentShuttleIDs[200];
	unsigned char NewShuttleIDs[200];
} McAcp6DChangeShIDParType;

typedef struct McAcp6DReadShIDTableType
{	unsigned char NumberOfEntries;
	unsigned char ShuttleIDs[150];
	unsigned long UIDHigh[150];
	unsigned long UIDLow[150];
} McAcp6DReadShIDTableType;

typedef struct McAcp6DWriteShIDTableType
{	unsigned char NumberOfEntries;
	unsigned char ShuttleIDs[127];
	enum McAcp6DShTypesEnum ShuttleTypes[127];
	unsigned long UIDHigh[127];
	unsigned long UIDLow[127];
} McAcp6DWriteShIDTableType;

typedef struct McAcp6DAsmEthernetCfgType
{	plcstring IpAddress[16];
	plcstring SubnetMask[16];
	plcstring Gateway[16];
} McAcp6DAsmEthernetCfgType;

typedef struct McAcp6DAsmSegSimCfgType
{	enum McAcp6DAssemblySegSimCfgEnum Mode;
} McAcp6DAsmSegSimCfgType;

typedef struct McAcp6DShDefPosCfgType
{	float Z;
	float Rx;
	float Ry;
	float Rz;
} McAcp6DShDefPosCfgType;

typedef struct McAcp6DInPlaneLimitsCfgType
{	float Velocity;
	float Acceleration;
	float EmergencyDeceleration;
} McAcp6DInPlaneLimitsCfgType;

typedef struct McAcp6DShortAxisLimisCfgVelType
{	float Rx;
	float Ry;
	float Rz;
	float Z;
} McAcp6DShortAxisLimisCfgVelType;

typedef struct McAcp6DShortAxisLimisCfgAccType
{	float Rx;
	float Ry;
	float Rz;
	float Z;
} McAcp6DShortAxisLimisCfgAccType;

typedef struct McAcp6DShortAxisLimitsCfgType
{	struct McAcp6DShortAxisLimisCfgVelType Velocity;
	struct McAcp6DShortAxisLimisCfgAccType Acceleration;
} McAcp6DShortAxisLimitsCfgType;

typedef struct McAcp6DLimitsCfgType
{	struct McAcp6DInPlaneLimitsCfgType InPlane;
	struct McAcp6DShortAxisLimitsCfgType ShortAxis;
} McAcp6DLimitsCfgType;

typedef struct McAcp6DAsmShuttlesCfgType
{	unsigned short MaxShuttleCount;
	enum McAcp6DAsmShuttleIDModeCfgEnum ShuttleIDMode;
	enum McAcp6DShTypesEnum RealModeDetectionType;
	struct McAcp6DShDefPosCfgType DefaultPosition;
	struct McAcp6DLimitsCfgType Limits;
} McAcp6DAsmShuttlesCfgType;

typedef struct McAcp6DLayoutUserOriginCfgType
{	float OffsetX;
	float OffsetY;
} McAcp6DLayoutUserOriginCfgType;

typedef struct McAcp6DSegmentsCfgType
{	unsigned long ArrayAddress;
	unsigned short ArraySize;
	unsigned short NumberOfSegments;
} McAcp6DSegmentsCfgType;

typedef struct McAcp6DAsmSyncCfgType
{	enum McAcp6DAsmSyncTypeCfgEnum Type;
	unsigned short SegmentID;
	enum McAcp6DAsmSyncEdgeCfgEnum Edge;
} McAcp6DAsmSyncCfgType;

typedef struct McAcp6DAsmLayoutCfgType
{	enum McAcp6DLayoutGridSizeCfgEnum GridSize;
	struct McAcp6DLayoutUserOriginCfgType UserOrigin;
	struct McAcp6DSegmentsCfgType Segments;
	struct McAcp6DAsmSyncCfgType Synchronization;
} McAcp6DAsmLayoutCfgType;

typedef struct McAcp6DSegmentGapsCfgType
{	enum McAcp6DSegmentGapSizeEnum Left;
	enum McAcp6DSegmentGapSizeEnum Bottom;
	enum McAcp6DSegmentGapSizeEnum Right;
	enum McAcp6DSegmentGapSizeEnum Top;
} McAcp6DSegmentGapsCfgType;

typedef struct McAcp6DSegmentBorderIDCfgType
{	enum McAcp6DSegmentGapSizeCfgEnum Left;
	enum McAcp6DSegmentGapSizeCfgEnum Bottom;
	enum McAcp6DSegmentGapSizeCfgEnum Right;
	enum McAcp6DSegmentGapSizeCfgEnum Top;
} McAcp6DSegmentBorderIDCfgType;

typedef struct McAcp6DSegmentCfgType
{	enum McAcp6DSegmentTypeEnum Type;
	signed short X;
	signed short Y;
	plcstring Name[81];
	plcbit IsMaster;
	plcstring PowerSectorName[81];
	struct McAcp6DSegmentGapsCfgType Gaps;
	struct McAcp6DSegmentBorderIDCfgType BorderID;
} McAcp6DSegmentCfgType;

typedef struct McAcp6DAsmCyclicReadCfgType
{	plcbit XAxis;
	plcbit YAxis;
	plcbit ZAxis;
	plcbit RxAxis;
	plcbit RyAxis;
	plcbit RzAxis;
} McAcp6DAsmCyclicReadCfgType;

typedef struct McAcp6DAsmCyclicChannelCfgType
{	struct McAcp6DAsmCyclicReadCfgType Read;
} McAcp6DAsmCyclicChannelCfgType;

typedef struct McAcp6DAsmSystemReactionsCfgType
{	enum McAcp6DAsmCommLossReactionEnum CommunicationLoss;
} McAcp6DAsmSystemReactionsCfgType;

typedef struct MC_BR_AsmPowerOn_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct Mc6DZoneType* Zone;
	enum McAcp6DAsmActivationOptionEnum Option;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmPowerOn_Acp6D_typ;

typedef struct MC_BR_AsmPowerOff_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmPowerOff_Acp6D_typ;

typedef struct MC_BR_AsmStop_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmStop_Acp6D_typ;

typedef struct MC_BR_AsmReboot_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmReboot_Acp6D_typ;

typedef struct MC_BR_AsmHalt_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	enum McAcp6DHaltOptionEnum Option;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmHalt_Acp6D_typ;

typedef struct MC_BR_AsmBuffer_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	enum McAcp6DAsmBufferOptionEnum Option;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmBuffer_Acp6D_typ;

typedef struct MC_BR_ShForceMode_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DForceModeParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShForceMode_Acp6D_typ;

typedef struct MC_BR_ShStereotypeDefine_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DShStereotypeParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShStereotypeDefine_Acp6D_typ;

typedef struct MC_BR_ShStereotypeAssign_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	plcstring Name[33];
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShStereotypeAssign_Acp6D_typ;

typedef struct MC_BR_ShStereotypeDelete_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	plcstring Name[33];
	enum McAcp6DShStereotypeDeleteCmdEnum Command;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShStereotypeDelete_Acp6D_typ;

typedef struct MC_BR_MacroDelete_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	plcstring Name[33];
	enum McAcp6DMacroDeleteCmdEnum Command;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MacroDelete_Acp6D_typ;

typedef struct MC_BR_MacroCreate_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DMacroCreateParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct Mc6DShuttleType MacroShuttle;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MacroCreate_Acp6D_typ;

typedef struct MC_BR_VirtualShCreate_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct Mc6DShuttleType VirtualShuttle;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_VirtualShCreate_Acp6D_typ;

typedef struct MC_BR_ShGroupCreate_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct Mc6DShuttleGroupType ShuttleGroup;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGroupCreate_Acp6D_typ;

typedef struct MC_BR_MacroSave_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MacroSave_Acp6D_typ;

typedef struct MC_BR_MacroClear_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MacroClear_Acp6D_typ;

typedef struct MC_BR_MacroRun_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	plcstring Name[33];
	unsigned short CommandLabel;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MacroRun_Acp6D_typ;

typedef struct MC_BR_ZoneCreate_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DCreateZoneParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ZoneCreate_Acp6D_typ;

typedef struct MC_BR_AsmLevitation_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DLevitationParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmLevitation_Acp6D_typ;

typedef struct MC_BR_AsmGetShuttle_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DShuttleType Shuttle;
	struct McAcp6DGetShAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmGetShuttle_Acp6D_typ;

typedef struct MC_BR_AsmGetVirtualSh_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DShuttleType VirtualShuttle;
	struct McAcp6DGetShAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmGetVirtualSh_Acp6D_typ;

typedef struct MC_BR_AsmGetSegment_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DSegmentType Segment;
	struct McAcp6DGetSegAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmGetSegment_Acp6D_typ;

typedef struct MC_BR_AsmGetZone_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DZoneType Zone;
	struct McAcp6DGetZoneAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmGetZone_Acp6D_typ;

typedef struct MC_BR_AsmGetShGroup_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DShuttleGroupType ShuttleGroup;
	struct McAcp6DGetShGroupAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmGetShGroup_Acp6D_typ;

typedef struct MC_BR_AsmGetInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DAsmGetInfoType AssemblyInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmGetInfo_Acp6D_typ;

typedef struct MC_BR_AsmGetErrCode_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DErrInfoType ErrInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmGetErrCode_Acp6D_typ;

typedef struct MC_BR_AsmReadStatus_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
	plcbit AssemblyDisabled;
	plcbit AssemblyReady;
	plcbit AssemblyHoming;
	plcbit AssemblyStopping;
	plcbit AssemblyStartUp;
	plcbit AssemblyErrorStop;
} MC_BR_AsmReadStatus_Acp6D_typ;

typedef struct MC_BR_AsmReadInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DAsmInfoType AssemblyInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmReadInfo_Acp6D_typ;

typedef struct MC_BR_ShReadInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DShInfoType ShuttleInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_ShReadInfo_Acp6D_typ;

typedef struct MC_BR_ShGetInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	enum McAcp6DShGetInfoOptionEnum Option;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DShGetInfoType ShuttleInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGetInfo_Acp6D_typ;

typedef struct MC_BR_ShGetProperty_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DShGetPropertyType ShuttleProperty;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGetProperty_Acp6D_typ;

typedef struct MC_BR_JogVelocity_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DJogVelocityParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Ready;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
	plcbit Jogging;
} MC_BR_JogVelocity_Acp6D_typ;

typedef struct MC_BR_MoveCyclicPosition_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DMoveCyclicParType Parameters;
	struct McAcp6DShPositionType CyclicPosition;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_MoveCyclicPosition_Acp6D_typ;

typedef struct MC_BR_ReadCyclicPosition_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DReadCyclicParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DShPositionType CyclicPosition;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_ReadCyclicPosition_Acp6D_typ;

typedef struct MC_BR_ReadCyclicForce_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DReadCyclicParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DShForceType CyclicForce;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_ReadCyclicForce_Acp6D_typ;

typedef struct MC_BR_MoveInPlaneAsync_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DMoveInPlaneAsyncParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MoveInPlaneAsync_Acp6D_typ;

typedef struct MC_BR_MoveInPlane_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DInPlaneParType Parameters;
	unsigned short CommandLabel;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MoveInPlane_Acp6D_typ;

typedef struct MC_BR_MoveShortAxis_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DShortAxParType Parameters;
	unsigned short CommandLabel;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MoveShortAxis_Acp6D_typ;

typedef struct MC_BR_MoveArc_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DArcParType Parameters;
	unsigned short CommandLabel;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_MoveArc_Acp6D_typ;

typedef struct MC_BR_ShLevitation_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DLevitationParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShLevitation_Acp6D_typ;

typedef struct MC_BR_Move6D_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DMove6DParType Parameters;
	unsigned short CommandLabel;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_Move6D_Acp6D_typ;

typedef struct MC_BR_ShBuffer_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	enum McAcp6DBufferOptionEnum Option;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DBufferInfoType BufferInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShBuffer_Acp6D_typ;

typedef struct MC_BR_ShStop_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShStop_Acp6D_typ;

typedef struct MC_BR_ShGetPayload_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	enum McAcp6DGetPayloadModeEnum Mode;
	float Duration;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	float Payload;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGetPayload_Acp6D_typ;

typedef struct MC_BR_ShHalt_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	enum McAcp6DHaltOptionEnum Option;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShHalt_Acp6D_typ;

typedef struct MC_BR_ShRecover_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	enum McAcp6DShRecovBufferOptEnum BufferOption;
	enum McAcp6DShRecovShortAxesOptEnum ShortAxesOption;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShRecover_Acp6D_typ;

typedef struct MC_BR_SegGetInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DSegmentType* Segment;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DSegInfoType SegInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_SegGetInfo_Acp6D_typ;

typedef struct MC_BR_SegGetBarrierInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DSegmentType* Segment;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DSegBarrierInfoType BarrierInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_SegGetBarrierInfo_Acp6D_typ;

typedef struct MC_BR_SegBarrierCommand_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DSegmentType* Segment;
	struct McAcp6DBarrierCmdParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_SegBarrierCommand_Acp6D_typ;

typedef struct MC_BR_SegPowerOff_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DSegmentType* Segment;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_SegPowerOff_Acp6D_typ;

typedef struct MC_BR_SegPowerOn_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DSegmentType* Segment;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_SegPowerOn_Acp6D_typ;

typedef struct MC_BR_ZonePowerOff_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DZoneType* Zone;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ZonePowerOff_Acp6D_typ;

typedef struct MC_BR_ZonePowerOn_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DZoneType* Zone;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ZonePowerOn_Acp6D_typ;

typedef struct MC_BR_ZoneBarrierCommand_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DZoneType* Zone;
	struct McAcp6DBarrierCmdParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ZoneBarrierCommand_Acp6D_typ;

typedef struct MC_BR_ZoneOverride_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DZoneType* Zone;
	struct McAcp6DZoneOverrideParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ZoneOverride_Acp6D_typ;

typedef struct MC_BR_ZoneGetBarrierInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DZoneType* Zone;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DZoneBarrierInfoType BarrierInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ZoneGetBarrierInfo_Acp6D_typ;

typedef struct MC_BR_AsmReset_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmReset_Acp6D_typ;

typedef struct MC_BR_ShPlanet_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DPlanetParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShPlanet_Acp6D_typ;

typedef struct MC_BR_ShGroupAddShuttle_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleGroupType* ShuttleGroup;
	struct McAcp6DShGroupAddShParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGroupAddShuttle_Acp6D_typ;

typedef struct MC_BR_ShGroupClear_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleGroupType* ShuttleGroup;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGroupClear_Acp6D_typ;

typedef struct MC_BR_ShGroupGetInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleGroupType* ShuttleGroup;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DShGroupInfoType Info;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGroupGetInfo_Acp6D_typ;

typedef struct MC_BR_ShGroupCoupleCtrl_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleGroupType* ShuttleGroup;
	struct McAcp6DShGroupCoupleCtrlParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGroupCoupleCtrl_Acp6D_typ;

typedef struct MC_BR_ShGroupBuffer_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleGroupType* ShuttleGroup;
	enum McAcp6DShGroupBufferOptionEnum Option;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGroupBuffer_Acp6D_typ;

typedef struct MC_BR_ShGroupDelete_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleGroupType* ShuttleGroup;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShGroupDelete_Acp6D_typ;

typedef struct MC_BR_AutoZoneCtrl_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	unsigned char ZoneID;
	enum McAcp6DAutoZoneCtrlCmdEnum ZoneCommand;
	struct McAcp6DAutoZoneCtrlParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoZoneCtrl_Acp6D_typ;

typedef struct MC_BR_AutoZoneGetStatus_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	unsigned char ZoneID;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DAutoZoneInfoTyp Info;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoZoneGetStatus_Acp6D_typ;

typedef struct MC_BR_AutoZoneClear_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	unsigned char ZoneID;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoZoneClear_Acp6D_typ;

typedef struct MC_BR_AutoZoneUnload_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	unsigned char ZoneID;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoZoneUnload_Acp6D_typ;

typedef struct MC_BR_ShWaitTime_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	unsigned short CommandLabel;
	float Delay;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShWaitTime_Acp6D_typ;

typedef struct MC_BR_ShWaitFBDI_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	unsigned short CommandLabel;
	unsigned char TriggerDI;
	enum McAcp6DShWaitFBDITriggerEnum TriggerType;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShWaitFBDI_Acp6D_typ;

typedef struct MC_BR_ShWaitCmdLb_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	unsigned short CommandLabel;
	unsigned short TriggerXID;
	enum McAcp6DShWaitCmdLbTriggerEnum TriggerType;
	unsigned short TriggerCmdLb;
	enum McAcp6DShWaitCmdLbLabelEnum LabelType;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShWaitCmdLb_Acp6D_typ;

typedef struct MC_BR_ShWaitDisp_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	unsigned short CommandLabel;
	unsigned short TriggerXID;
	enum McAcp6DShWaitDispModeEnum DispMode;
	enum McAcp6DShWaitDispTypeEnum DispType;
	float Treshold;
	float PosXFactor;
	float PosYFactor;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShWaitDisp_Acp6D_typ;

typedef struct MC_BR_ShWaitZone_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	unsigned short CommandLabel;
	struct Mc6DZoneType* Zone;
	enum McAcp6DShWaitZoneTriggerEnum TriggerType;
	unsigned char Threshold;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShWaitZone_Acp6D_typ;

typedef struct MC_BR_RotaryMotion_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DRotaryMotionParType Parameters;
	unsigned short CommandLabel;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_RotaryMotion_Acp6D_typ;

typedef struct MC_BR_RotaryMotionSpin_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DRotaryMotionSpinParType Parameters;
	unsigned short CommandLabel;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_RotaryMotionSpin_Acp6D_typ;

typedef struct MC_BR_6DCtrlGetSerialNum_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DSerialNumType SerialNum;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_6DCtrlGetSerialNum_Acp6D_typ;

typedef struct MC_BR_6DCtrlGetVersion_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DVersionNumType Version;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_6DCtrlGetVersion_Acp6D_typ;

typedef struct MC_BR_AsmGetPowerSec_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DPowerSecType PowerSec;
	struct McAcp6DGetPowerSecAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmGetPowerSec_Acp6D_typ;

typedef struct MC_BR_PowerSecDeactivate_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DPowerSecType* PowerSec;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_PowerSecDeactivate_Acp6D_typ;

typedef struct MC_BR_PowerSecActivate_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DPowerSecType* PowerSec;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Acknowledge;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_PowerSecActivate_Acp6D_typ;

typedef struct MC_BR_PowerSecRecover_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DPowerSecType* PowerSec;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_PowerSecRecover_Acp6D_typ;

typedef struct MC_BR_PowerSecGetShuttle_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DPowerSecType* PowerSec;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DShuttleType Shuttle;
	struct McAcp6DGetShAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_PowerSecGetShuttle_Acp6D_typ;

typedef struct MC_BR_PowerSecGetInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DPowerSecType* PowerSec;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DPowerSecInfoType PowerSecInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_PowerSecGetInfo_Acp6D_typ;

typedef struct MC_BR_ShSetJerkLimit_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	struct McAcp6DSetJerkLimitParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShSetJerkLimit_Acp6D_typ;

typedef struct MC_BR_AsmSetJerkLimit_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DSetJerkLimitParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmSetJerkLimit_Acp6D_typ;

typedef struct MC_BR_AsmGetAccidentSh_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short TotalCount;
	unsigned short RemainingCount;
	struct Mc6DShuttleType AccidentShuttle;
	struct McAcp6DGetShAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit Next;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmGetAccidentSh_Acp6D_typ;

typedef struct MC_BR_ShStereotypeGetInfo_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	plcstring Name[33];
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DStereotypeGetInfoType StereotypeInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_ShStereotypeGetInfo_Acp6D_typ;

typedef struct MC_BR_AutoZoneGetAllStatus_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DAutoZoneAllInfoType Info;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AutoZoneGetAllStatus_Acp6D_typ;

typedef struct MC_BR_AsmReadArrivedSh_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	unsigned short ArrivedShuttleCount;
	struct Mc6DShuttleType Shuttle;
	struct McAcp6DReadArrivedShAddInfoType AdditionalInfo;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit GetShuttle;
	/* VAR_OUTPUT (digital) */
	plcbit Valid;
	plcbit Busy;
	plcbit Error;
} MC_BR_AsmReadArrivedSh_Acp6D_typ;

typedef struct MC_BR_AsmGetBorderStatus_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	unsigned char BorderID;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	enum McAcp6DAsmBorderStateEnum State;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmGetBorderStatus_Acp6D_typ;

typedef struct MC_BR_AsmStereotypeAssign_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	plcstring Name[33];
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmStereotypeAssign_Acp6D_typ;

typedef struct MC_BR_AsmResetShIDTable_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmResetShIDTable_Acp6D_typ;

typedef struct MC_BR_AsmChangeShID_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DChangeShIDParType Parameters;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmChangeShID_Acp6D_typ;

typedef struct MC_BR_AsmReadShIDTable_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	struct McAcp6DReadShIDTableType ShIDTable;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmReadShIDTable_Acp6D_typ;

typedef struct MC_BR_ShCopyUserData_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DShuttleType* Shuttle;
	unsigned long DataAddress;
	unsigned long DataSize;
	enum McAcp6DUserDataModeEnum Mode;
	plcstring (*ProductLabel);
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} MC_BR_ShCopyUserData_Acp6D_typ;

typedef struct MC_BR_AsmWriteShIDTable_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DWriteShIDTableType ShIDTable;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit CommandAborted;
	plcbit Error;
} MC_BR_AsmWriteShIDTable_Acp6D_typ;

typedef struct MC_BR_AsmConfigHandler_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit LoadToParam;
	plcbit SaveFromParam;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MC_BR_AsmConfigHandler_Acp6D_typ;

typedef struct MC_BR_AsmParam_Acp6D
{
	/* VAR_INPUT (analog) */
	struct Mc6DAssemblyType* Assembly;
	struct McAcp6DAsmSegSimCfgType* SegSim;
	struct McAcp6DAsmEthernetCfgType* Ethernet;
	struct McAcp6DAsmShuttlesCfgType* Shuttles;
	struct McAcp6DAsmCyclicChannelCfgType* CyclicChannel;
	struct McAcp6DAsmSystemReactionsCfgType* SystemReactions;
	struct McAcp6DAsmLayoutCfgType* Layout;
	/* VAR_OUTPUT (analog) */
	signed long ErrorID;
	/* VAR (analog) */
	struct McInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Read;
	plcbit Write;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MC_BR_AsmParam_Acp6D_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MC_BR_AsmPowerOn_Acp6D(struct MC_BR_AsmPowerOn_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmPowerOff_Acp6D(struct MC_BR_AsmPowerOff_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmStop_Acp6D(struct MC_BR_AsmStop_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmReboot_Acp6D(struct MC_BR_AsmReboot_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmHalt_Acp6D(struct MC_BR_AsmHalt_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmBuffer_Acp6D(struct MC_BR_AsmBuffer_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShForceMode_Acp6D(struct MC_BR_ShForceMode_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShStereotypeDefine_Acp6D(struct MC_BR_ShStereotypeDefine_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShStereotypeAssign_Acp6D(struct MC_BR_ShStereotypeAssign_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShStereotypeDelete_Acp6D(struct MC_BR_ShStereotypeDelete_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MacroDelete_Acp6D(struct MC_BR_MacroDelete_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MacroCreate_Acp6D(struct MC_BR_MacroCreate_Acp6D* inst);
_BUR_PUBLIC void MC_BR_VirtualShCreate_Acp6D(struct MC_BR_VirtualShCreate_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGroupCreate_Acp6D(struct MC_BR_ShGroupCreate_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MacroSave_Acp6D(struct MC_BR_MacroSave_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MacroClear_Acp6D(struct MC_BR_MacroClear_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MacroRun_Acp6D(struct MC_BR_MacroRun_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ZoneCreate_Acp6D(struct MC_BR_ZoneCreate_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmLevitation_Acp6D(struct MC_BR_AsmLevitation_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetShuttle_Acp6D(struct MC_BR_AsmGetShuttle_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetVirtualSh_Acp6D(struct MC_BR_AsmGetVirtualSh_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetSegment_Acp6D(struct MC_BR_AsmGetSegment_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetZone_Acp6D(struct MC_BR_AsmGetZone_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetShGroup_Acp6D(struct MC_BR_AsmGetShGroup_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetInfo_Acp6D(struct MC_BR_AsmGetInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetErrCode_Acp6D(struct MC_BR_AsmGetErrCode_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmReadStatus_Acp6D(struct MC_BR_AsmReadStatus_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmReadInfo_Acp6D(struct MC_BR_AsmReadInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShReadInfo_Acp6D(struct MC_BR_ShReadInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGetInfo_Acp6D(struct MC_BR_ShGetInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGetProperty_Acp6D(struct MC_BR_ShGetProperty_Acp6D* inst);
_BUR_PUBLIC void MC_BR_JogVelocity_Acp6D(struct MC_BR_JogVelocity_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MoveCyclicPosition_Acp6D(struct MC_BR_MoveCyclicPosition_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ReadCyclicPosition_Acp6D(struct MC_BR_ReadCyclicPosition_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ReadCyclicForce_Acp6D(struct MC_BR_ReadCyclicForce_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MoveInPlaneAsync_Acp6D(struct MC_BR_MoveInPlaneAsync_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MoveInPlane_Acp6D(struct MC_BR_MoveInPlane_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MoveShortAxis_Acp6D(struct MC_BR_MoveShortAxis_Acp6D* inst);
_BUR_PUBLIC void MC_BR_MoveArc_Acp6D(struct MC_BR_MoveArc_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShLevitation_Acp6D(struct MC_BR_ShLevitation_Acp6D* inst);
_BUR_PUBLIC void MC_BR_Move6D_Acp6D(struct MC_BR_Move6D_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShBuffer_Acp6D(struct MC_BR_ShBuffer_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShStop_Acp6D(struct MC_BR_ShStop_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGetPayload_Acp6D(struct MC_BR_ShGetPayload_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShHalt_Acp6D(struct MC_BR_ShHalt_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShRecover_Acp6D(struct MC_BR_ShRecover_Acp6D* inst);
_BUR_PUBLIC void MC_BR_SegGetInfo_Acp6D(struct MC_BR_SegGetInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_SegGetBarrierInfo_Acp6D(struct MC_BR_SegGetBarrierInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_SegBarrierCommand_Acp6D(struct MC_BR_SegBarrierCommand_Acp6D* inst);
_BUR_PUBLIC void MC_BR_SegPowerOff_Acp6D(struct MC_BR_SegPowerOff_Acp6D* inst);
_BUR_PUBLIC void MC_BR_SegPowerOn_Acp6D(struct MC_BR_SegPowerOn_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ZonePowerOff_Acp6D(struct MC_BR_ZonePowerOff_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ZonePowerOn_Acp6D(struct MC_BR_ZonePowerOn_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ZoneBarrierCommand_Acp6D(struct MC_BR_ZoneBarrierCommand_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ZoneOverride_Acp6D(struct MC_BR_ZoneOverride_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ZoneGetBarrierInfo_Acp6D(struct MC_BR_ZoneGetBarrierInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmReset_Acp6D(struct MC_BR_AsmReset_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShPlanet_Acp6D(struct MC_BR_ShPlanet_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGroupAddShuttle_Acp6D(struct MC_BR_ShGroupAddShuttle_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGroupClear_Acp6D(struct MC_BR_ShGroupClear_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGroupGetInfo_Acp6D(struct MC_BR_ShGroupGetInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGroupCoupleCtrl_Acp6D(struct MC_BR_ShGroupCoupleCtrl_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGroupBuffer_Acp6D(struct MC_BR_ShGroupBuffer_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShGroupDelete_Acp6D(struct MC_BR_ShGroupDelete_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AutoZoneCtrl_Acp6D(struct MC_BR_AutoZoneCtrl_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AutoZoneGetStatus_Acp6D(struct MC_BR_AutoZoneGetStatus_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AutoZoneClear_Acp6D(struct MC_BR_AutoZoneClear_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AutoZoneUnload_Acp6D(struct MC_BR_AutoZoneUnload_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShWaitTime_Acp6D(struct MC_BR_ShWaitTime_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShWaitFBDI_Acp6D(struct MC_BR_ShWaitFBDI_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShWaitCmdLb_Acp6D(struct MC_BR_ShWaitCmdLb_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShWaitDisp_Acp6D(struct MC_BR_ShWaitDisp_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShWaitZone_Acp6D(struct MC_BR_ShWaitZone_Acp6D* inst);
_BUR_PUBLIC void MC_BR_RotaryMotion_Acp6D(struct MC_BR_RotaryMotion_Acp6D* inst);
_BUR_PUBLIC void MC_BR_RotaryMotionSpin_Acp6D(struct MC_BR_RotaryMotionSpin_Acp6D* inst);
_BUR_PUBLIC void MC_BR_6DCtrlGetSerialNum_Acp6D(struct MC_BR_6DCtrlGetSerialNum_Acp6D* inst);
_BUR_PUBLIC void MC_BR_6DCtrlGetVersion_Acp6D(struct MC_BR_6DCtrlGetVersion_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetPowerSec_Acp6D(struct MC_BR_AsmGetPowerSec_Acp6D* inst);
_BUR_PUBLIC void MC_BR_PowerSecDeactivate_Acp6D(struct MC_BR_PowerSecDeactivate_Acp6D* inst);
_BUR_PUBLIC void MC_BR_PowerSecActivate_Acp6D(struct MC_BR_PowerSecActivate_Acp6D* inst);
_BUR_PUBLIC void MC_BR_PowerSecRecover_Acp6D(struct MC_BR_PowerSecRecover_Acp6D* inst);
_BUR_PUBLIC void MC_BR_PowerSecGetShuttle_Acp6D(struct MC_BR_PowerSecGetShuttle_Acp6D* inst);
_BUR_PUBLIC void MC_BR_PowerSecGetInfo_Acp6D(struct MC_BR_PowerSecGetInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShSetJerkLimit_Acp6D(struct MC_BR_ShSetJerkLimit_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmSetJerkLimit_Acp6D(struct MC_BR_AsmSetJerkLimit_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetAccidentSh_Acp6D(struct MC_BR_AsmGetAccidentSh_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShStereotypeGetInfo_Acp6D(struct MC_BR_ShStereotypeGetInfo_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AutoZoneGetAllStatus_Acp6D(struct MC_BR_AutoZoneGetAllStatus_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmReadArrivedSh_Acp6D(struct MC_BR_AsmReadArrivedSh_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmGetBorderStatus_Acp6D(struct MC_BR_AsmGetBorderStatus_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmStereotypeAssign_Acp6D(struct MC_BR_AsmStereotypeAssign_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmResetShIDTable_Acp6D(struct MC_BR_AsmResetShIDTable_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmChangeShID_Acp6D(struct MC_BR_AsmChangeShID_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmReadShIDTable_Acp6D(struct MC_BR_AsmReadShIDTable_Acp6D* inst);
_BUR_PUBLIC void MC_BR_ShCopyUserData_Acp6D(struct MC_BR_ShCopyUserData_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmWriteShIDTable_Acp6D(struct MC_BR_AsmWriteShIDTable_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmConfigHandler_Acp6D(struct MC_BR_AsmConfigHandler_Acp6D* inst);
_BUR_PUBLIC void MC_BR_AsmParam_Acp6D(struct MC_BR_AsmParam_Acp6D* inst);


#ifdef __cplusplus
};
#endif
#endif /* _MCACP6D_ */

