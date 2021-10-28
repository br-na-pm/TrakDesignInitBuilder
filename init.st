//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Copyright B&R Industrial Automation GmbH
// Author    B&R
// Created   Feb 1, 2018
//
// trak assembly design support task (optional)
// TC#1 => mandatory to be attached to mappMotion task class
//
// * calculates/estimates the assembly power consumption
// * calculates/estimates the segment power losses
// * analyzes the mechanical situation (does the shuttle stay in the standard-B&R guiding rails?, ist thrust force sufficient?)
// * suitable for use in ARsim (and on real HW)
//
// "TrakDesign" - local interface structure
// "gTrakDesignShuttleOnline" - global interface structure, not mandatory
//
// CAUTION: this task can cause high CPU load on real HW
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



PROGRAM _INIT

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// configuration

	// general parameter
	TrakDesign.AssemblyRef			:= ADR(gAssembly_1);
	TrakDesign.AssemblyName			:= 'gAssembly_1';
	TrakDesign.EnableCalc			:= DiagCpuIsSimulated();	//TRUE;
	TrakDesign.CmdReset				:= FALSE;
	TrakDesign.CmdSaveReport		:= FALSE;
	TrakDesign.CmdRecordToolData	:= FALSE;

	TrakDesign.ParaShuttleType		:= SA203_100N;
	TrakDesign.ParaTempAmbient		:= 30;

//	TrakDesign.ParaMechShuttleIx	:= 1;
	TrakDesign.ParaFileDevice		:= 'User';
	TrakDesign.ParaFileNameReport	:= 'TrakDesignReport.csv';
	TrakDesign.ParaFileNameToolData	:= 'TrakDesignToolData.dat';
	TrakDesign.ParaFileCsvStyle		:= 1;
	TrakDesign.ParaToolDataPrescale	:= 10;

	// shuttle payload parameter
	// carrier
	TrakDesign.Carrier.ParaMass					:= 0.5;			// [kg]
	TrakDesign.Carrier.ParaMassCenterX			:= 0.0;			// [m]
	TrakDesign.Carrier.ParaMassCenterY			:= 0.0;			// [m]
	TrakDesign.Carrier.ParaMassCenterZ			:= 0.0;			// [m]
	TrakDesign.Carrier.ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// product
	TrakDesign.Payload[1].ParaName				:= 'no force, mass';
	TrakDesign.Payload[1].ParaMass				:= 0.0;			// [kg]
	TrakDesign.Payload[1].ParaMassCenterX		:= 0.0;			// [m]
	TrakDesign.Payload[1].ParaMassCenterY		:= 0.0;			// [m]
	TrakDesign.Payload[1].ParaMassCenterZ		:= 0.0;			// [m]
	TrakDesign.Payload[1].ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// external friction/force
	TrakDesign.Payload[1].ParaExtFrictionX		:= 0.0;			// [N]
	TrakDesign.Payload[1].ParaExtFrictionVelX	:= 0.0;			// [N/(m/s)]
	TrakDesign.Payload[1].ParaExtForceX			:= 0.0;			// [N]
	TrakDesign.Payload[1].ParaExtForceY			:= 0.0;			// [N]
	TrakDesign.Payload[1].ParaExtForceZ			:= 0.0;			// [N]
	TrakDesign.Payload[1].ParaExtForceAppPointX	:= 0.0;			// [m]
	TrakDesign.Payload[1].ParaExtForceAppPointY	:= 0.0;			// [m]
	TrakDesign.Payload[1].ParaExtForceAppPointZ	:= 0.0;			// [m]
	// product
	TrakDesign.Payload[2].ParaName				:= 'Rear,Load,Const,Grip';
	TrakDesign.Payload[2].ParaMass				:= 4.5;			// [kg]
	TrakDesign.Payload[2].ParaMassCenterX		:= 0.0;			// [m]
	TrakDesign.Payload[2].ParaMassCenterY		:= -0.05;		// [m]
	TrakDesign.Payload[2].ParaMassCenterZ		:= 0.0;			// [m]
	TrakDesign.Payload[2].ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// external friction/force
	TrakDesign.Payload[2].ParaExtFrictionX		:= 0.0;			// [N]
	TrakDesign.Payload[2].ParaExtFrictionVelX	:= 0.0;			// [N/(m/s)]
	TrakDesign.Payload[2].ParaExtForceX			:= -10.0;		// [N]
	TrakDesign.Payload[2].ParaExtForceY			:= 0.0;			// [N]
	TrakDesign.Payload[2].ParaExtForceZ			:= 0.0;			// [N]
	TrakDesign.Payload[2].ParaExtForceAppPointX	:= 0.0;			// [m]
	TrakDesign.Payload[2].ParaExtForceAppPointY	:= -0.05;		// [m]
	TrakDesign.Payload[2].ParaExtForceAppPointZ	:= 0.0;			// [m]
	// product
	TrakDesign.Payload[3].ParaName				:= 'Rear,Load,Accel,Grip';
	TrakDesign.Payload[3].ParaMass				:= 9.0;			// [kg]
	TrakDesign.Payload[3].ParaMassCenterX		:= 0.0;			// [m]
	TrakDesign.Payload[3].ParaMassCenterY		:= -0.05;			// [m]
	TrakDesign.Payload[3].ParaMassCenterZ		:= 0.0;			// [m]
	TrakDesign.Payload[3].ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// external frictio3/force
	TrakDesign.Payload[3].ParaExtFrictionX		:= 0.0;			// [N]
	TrakDesign.Payload[3].ParaExtFrictionVelX	:= 0.0;			// [N/(m/s)]
	TrakDesign.Payload[3].ParaExtForceX			:= -10.0;			// [N]
	TrakDesign.Payload[3].ParaExtForceY			:= 0.0;			// [N]
	TrakDesign.Payload[3].ParaExtForceZ			:= 0.0;			// [N]
	TrakDesign.Payload[3].ParaExtForceAppPointX	:= 0.0;			// [m]
	TrakDesign.Payload[3].ParaExtForceAppPointY	:= -0.05;			// [m]
	TrakDesign.Payload[3].ParaExtForceAppPointZ	:= 0.0;			// [m]
	// product
	TrakDesign.Payload[4].ParaName				:= 'Rear,Load,Plow,Grip';
	TrakDesign.Payload[4].ParaMass				:= 4.5;			// [kg]
	TrakDesign.Payload[4].ParaMassCenterX		:= 0.0;			// [m]
	TrakDesign.Payload[4].ParaMassCenterY		:= -0.05;			// [m]
	TrakDesign.Payload[4].ParaMassCenterZ		:= 0.0;			// [m]
	TrakDesign.Payload[4].ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// external frictio4/force
	TrakDesign.Payload[4].ParaExtFrictionX		:= 0.0;			// [N]
	TrakDesign.Payload[4].ParaExtFrictionVelX	:= 0.0;			// [N/(m/s)]
	TrakDesign.Payload[4].ParaExtForceX			:= -70.0;			// [N]
	TrakDesign.Payload[4].ParaExtForceY			:= 0.0;			// [N]
	TrakDesign.Payload[4].ParaExtForceZ			:= 0.0;			// [N]
	TrakDesign.Payload[4].ParaExtForceAppPointX	:= 0.0;			// [m]
	TrakDesign.Payload[4].ParaExtForceAppPointY	:= -0.05;			// [m]
	TrakDesign.Payload[4].ParaExtForceAppPointZ	:= 0.0;			// [m]
	// product
	TrakDesign.Payload[5].ParaName				:= 'Front,Load,Const,Grip';
	TrakDesign.Payload[5].ParaMass				:= 4.5;			// [kg]
	TrakDesign.Payload[5].ParaMassCenterX		:= 0.0;			// [m]
	TrakDesign.Payload[5].ParaMassCenterY		:= -0.05;		// [m]
	TrakDesign.Payload[5].ParaMassCenterZ		:= 0.0;			// [m]
	TrakDesign.Payload[5].ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// external frictio5/force
	TrakDesign.Payload[5].ParaExtFrictionX		:= 0.0;			// [N]
	TrakDesign.Payload[5].ParaExtFrictionVelX	:= 0.0;			// [N/(m/s)]
	TrakDesign.Payload[5].ParaExtForceX			:= 10.0;		// [N]
	TrakDesign.Payload[5].ParaExtForceY			:= 0.0;			// [N]
	TrakDesign.Payload[5].ParaExtForceZ			:= 0.0;			// [N]
	TrakDesign.Payload[5].ParaExtForceAppPointX	:= 0.0;			// [m]
	TrakDesign.Payload[5].ParaExtForceAppPointY	:= -0.05;		// [m]
	TrakDesign.Payload[5].ParaExtForceAppPointZ	:= 0.0;			// [m]
	// product
	TrakDesign.Payload[6].ParaName				:= 'Front,Load,Decel,Grip';
	TrakDesign.Payload[6].ParaMass				:= 9.0;			// [kg]
	TrakDesign.Payload[6].ParaMassCenterX		:= 0.0;			// [m]
	TrakDesign.Payload[6].ParaMassCenterY		:= -0.05;		// [m]
	TrakDesign.Payload[6].ParaMassCenterZ		:= 0.0;			// [m]
	TrakDesign.Payload[6].ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// external frictio6/force
	TrakDesign.Payload[6].ParaExtFrictionX		:= 0.0;			// [N]
	TrakDesign.Payload[6].ParaExtFrictionVelX	:= 0.0;			// [N/(m/s)]
	TrakDesign.Payload[6].ParaExtForceX			:= 10.0;		// [N]
	TrakDesign.Payload[6].ParaExtForceY			:= 0.0;			// [N]
	TrakDesign.Payload[6].ParaExtForceZ			:= 0.0;			// [N]
	TrakDesign.Payload[6].ParaExtForceAppPointX	:= 0.0;			// [m]
	TrakDesign.Payload[6].ParaExtForceAppPointY	:= -0.05;		// [m]
	TrakDesign.Payload[6].ParaExtForceAppPointZ	:= 0.0;			// [m]
	// product
	TrakDesign.Payload[7].ParaName				:= 'Front,Load,Plow,Grip';
	TrakDesign.Payload[7].ParaMass				:= 4.5;			// [kg]
	TrakDesign.Payload[7].ParaMassCenterX		:= 0.0;			// [m]
	TrakDesign.Payload[7].ParaMassCenterY		:= -0.05;		// [m]
	TrakDesign.Payload[7].ParaMassCenterZ		:= 0.0;			// [m]
	TrakDesign.Payload[7].ParaMassInertiaZZ		:= 0.0;			// [kg m^2]
	// external frictio7/force
	TrakDesign.Payload[7].ParaExtFrictionX		:= 0.0;			// [N]
	TrakDesign.Payload[7].ParaExtFrictionVelX	:= 0.0;			// [N/(m/s)]
	TrakDesign.Payload[7].ParaExtForceX			:= 0.0;			// [N]
	TrakDesign.Payload[7].ParaExtForceY			:= 0.0;			// [N]
	TrakDesign.Payload[7].ParaExtForceZ			:= 0.0;			// [N]
	TrakDesign.Payload[7].ParaExtForceAppPointX	:= 0.0;			// [m]
	TrakDesign.Payload[7].ParaExtForceAppPointY	:= 0.0;			// [m]
	TrakDesign.Payload[7].ParaExtForceAppPointZ	:= 0.0;			// [m]


	FOR i:=1 TO TRAK_MAX_SHUTTLE DO
		TrakDesign.Shuttle[i].ParaPayloadIx					:= 1;
		TrakDesign.Shuttle[i].ParaAutoPayload				:= 0;
		//		TrakDesign.Shuttle[i].ParaInitialOrientationFlip	:= 1;
	END_FOR

	// segment assembly

	TrakDesign.Cable[2].ParaLength := 10.0;			TrakDesign.Cable[2].ParaIxSupply := 1;
	TrakDesign.Cable[3].ParaLength := 10.0;			TrakDesign.Cable[3].ParaIxSupply := 3;
	TrakDesign.Cable[4].ParaLength := 10.0;			TrakDesign.Cable[4].ParaIxSupply := 3;
	TrakDesign.Cable[5].ParaLength := 10.0;			TrakDesign.Cable[5].ParaIxSupply := 5;
	TrakDesign.Cable[6].ParaLength := 10.0;			TrakDesign.Cable[6].ParaIxSupply := 5;
	TrakDesign.Cable[7].ParaLength := 10.0;			TrakDesign.Cable[7].ParaIxSupply := 7;
	TrakDesign.Cable[8].ParaLength := 10.0;			TrakDesign.Cable[8].ParaIxSupply := 7;
	TrakDesign.Cable[9].ParaLength := 10.0;			TrakDesign.Cable[9].ParaIxSupply := 9;
	TrakDesign.Cable[10].ParaLength := 10.0;		TrakDesign.Cable[10].ParaIxSupply := 9;
	TrakDesign.Cable[11].ParaLength := 10.0;		TrakDesign.Cable[11].ParaIxSupply := 11;

	// power supply assembly
	//	TrakDesign.Supply[1].ParaName := 'gAxis_BC032_1';	TrakDesign.Supply[1].ParaType := BC032;			TrakDesign.Supply[1].ParaIxSupplyParallel := 0;
	TrakDesign.Supply[1].ParaName := '';				TrakDesign.Supply[1].ParaType := PS080;			TrakDesign.Supply[1].ParaIxSupplyParallel := 2;
	TrakDesign.Supply[2].ParaName := '';				TrakDesign.Supply[2].ParaType := PS080;			TrakDesign.Supply[2].ParaIxSupplyParallel := 1;
	TrakDesign.Supply[3].ParaName := '';				TrakDesign.Supply[3].ParaType := PS080;			TrakDesign.Supply[3].ParaIxSupplyParallel := 4;
	TrakDesign.Supply[4].ParaName := '';				TrakDesign.Supply[4].ParaType := PS080;			TrakDesign.Supply[4].ParaIxSupplyParallel := 3;
	TrakDesign.Supply[5].ParaName := '';				TrakDesign.Supply[5].ParaType := PS080;			TrakDesign.Supply[5].ParaIxSupplyParallel := 6;
	TrakDesign.Supply[6].ParaName := '';				TrakDesign.Supply[6].ParaType := PS080;			TrakDesign.Supply[6].ParaIxSupplyParallel := 5;
	TrakDesign.Supply[7].ParaName := '';				TrakDesign.Supply[7].ParaType := PS080;			TrakDesign.Supply[7].ParaIxSupplyParallel := 8;
	TrakDesign.Supply[8].ParaName := '';				TrakDesign.Supply[8].ParaType := PS080;			TrakDesign.Supply[8].ParaIxSupplyParallel := 7;
	TrakDesign.Supply[9].ParaName := '';				TrakDesign.Supply[9].ParaType := PS080;			TrakDesign.Supply[5].ParaIxSupplyParallel := 10;
	TrakDesign.Supply[10].ParaName := '';				TrakDesign.Supply[10].ParaType := PS080;			TrakDesign.Supply[6].ParaIxSupplyParallel := 9;
	TrakDesign.Supply[11].ParaName := '';				TrakDesign.Supply[11].ParaType := PS080;			TrakDesign.Supply[7].ParaIxSupplyParallel := 12;
	TrakDesign.Supply[12].ParaName := '';				TrakDesign.Supply[12].ParaType := PS080;			TrakDesign.Supply[8].ParaIxSupplyParallel := 11;

	//	ExpertReport := TRUE;
	//	CreateFileHistory := TRUE;







	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// VVV do not modify rest of task INIT source VVV

	Action_INIT;

END_PROGRAM
