class KnifePistolSpeedupMut extends KFMutator
			Config(KnifeMut);
		var const class<KFWeapon> KFWeapKnife2;
		var const class<KFWeapon> KFWeapPistol2; //Unused
		var class<KFWeapon> CurrentKnife;
		var KFPerk KFP;
		var config  float MovespeedMulitplier;
		var config bool bConfigsInit;
		var config float ParryBlockMultiplier;
		var class<KFPerk> PerkClass;
		var Class<KFPerk> CurClass; //can be used with Class'CurClass'
		var bool bSupportedPerk;
		var KFInventoryManager KFIM;// Inventory manager
		var pawn CurPawn;
		var inventory Inv;
		var KFWeapon DefaultKnife;
		var KFWeapon KFWeapknife2class;
		var KFPerk_Survivalist KFSurv;//This line will be used to check if Melee Expert is active

	function InitMutator(string Options, out string ErrorMessage)
	{
		local String CurrentError;
		CurrentError = ErrorMessage;
		super.InitMutator( Options, ErrorMessage ); 
		`log("********  KnifePistolSpeedup Mutator initialized ********");
			if (CurrentError != "")
			{
				`log("******** Error Encountered: ********");
				`log(CurrentError);
				`log("******** Error End ********");
			}
		ConfigCheck();
	}

	//Prevents the game from adding this mutator multiple times
	function AddMutator(Mutator M)
	{
		if( M != Self)
		{
			if(M.Class==Class)
				M.Destroy();
			else Super.AddMutator(M);
		}
	}

	function ConfigCheck()
	{
		if (!bConfigsInit || MovespeedMulitplier > 1.25 || ParryBlockMultiplier < 0.4 || MovespeedMulitplier == 0)
		{
			if(MovespeedMulitplier > 1.25 || MovespeedMulitplier == 0){MovespeedMulitplier = 1.25;`log("****** KnifePistolSpeedupMut:- Movement Speed Multiplier is not Accepted, Resetting to 1.25 ******");}
			if(ParryBlockMultiplier < 0.4){ParryBlockMultiplier = 0.4;`log("****** KnifePistolSpeedupMut:- Knife Block/Parry Multiplier is not Accepted, 	Resetting to 0.4 ******");}
			bConfigsInit = true;
			saveconfig();
			`log("****** KnifePistolSpeedupMut:- Movement Speed Set to 1.25, Parry/Block Multiplier is set to 0.4 and Config File Saved");
		}
		else if (bConfigsInit && MovespeedMulitplier <= 1.25 && ParryBlockMultiplier < 0.4)
		{
			`log("****** KnifePistolSpeedupMut:- Movement Speed is Accepted: " $ MovespeedMulitplier $ " ******");
			`log("****** KnifePistolSpeedupMut:- Parry/Block Multiplier is Accepted: " $ ParryBlockMultiplier $ " ******");

		}
		else
		{
			`log("****** KnifePistolSpeedupMut:- bConfigsInit status is: " $ bConfigsInit $ " ******");						
			`log("****** KnifePistolSpeedupMut:- Parry/Block Multiplier is: " $ ParryBlockMultiplier $ " ******");			
			`log("****** KnifePistolSpeedupMut:- Movement Speed is: " $ MovespeedMulitplier $ " ******");
			`log("****** KnifePistolSpeedupMut:- Unknown case, Please contact the developer" );
			saveconfig();
		}
	}

	function PostBeginPlay()
	{
		Super.PostBeginPlay();	
	}

	function ModifyPlayer(Pawn P) // Function to modify the player
	{
		Super.ModifyPlayer(P);
		if (P != none)
		{
				Curpawn = P;
				Settimer(10,true, nameof(TryKnives)); //Sets a timer that checks for the knife to be given to the player
		}
	}


	function TryKnives()
	{
			local Controller C;
		    foreach WorldInfo.AllControllers( class'Controller', C)
		    {
			    	if(C.bIsPlayer == false) //This small check will help loop through all zeds and players quicker
			    		continue;
				    else if( C.bIsPlayer
		        	&& C.PlayerReplicationInfo != none
		        	&& C.PlayerReplicationInfo.bReadyToPlay
		        	&& !C.PlayerReplicationInfo.bOnlySpectator
		        	&& C.GetTeamNum() == 0 ) //Checks for a human player
			        {
			        	Curpawn = KFPawn_Human(KFPlayerController(C).AcknowledgedPawn);
			        }
				KFP = kfpawn(curpawn).GetPerk(); //This gets KFPerk
				KFIM = KFInventoryManager(kfPawn(Curpawn).InvManager);
					if( KFP != None && kfp.GetPerkClass() != Curclass
						|| KFP != None && !IsMeleeExpertActive() && PlayerHasSurvKnife()
						|| SurvHasWrongKnife()) //Checks if the last saved perk is the currently used one, if the current perk is not defined yet. Also checks it player has the survivalist knife
					{
						`log("KnifePistolSpeedupMut:- Current Perk is: " $ KFP.GetPerkClass());
						`log("KnifePistolSpeedupMut:- Survivalist Melee Expert Check is: " $ IsMeleeExpertActive());
						`log("KnifePistolSpeedupMut:- Last Perk Check was:" $  Curclass);
						if(DefaultKnife == None) DefaultKnife = None; // A trick to avoid warnings in the compiler
						if(kFIM != None)
						{
							KnifeFind(DefaultKnife, 'KnifeMut'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Berserker'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_FieldMedic'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Gunslinger'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Commando'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Support'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Demolitionist'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Firebug'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Sharpshooter'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_Survivalist'); //Checked
							KnifeFind(DefaultKnife, 'KFWeap_Knife_SWAT'); //Checked
							`log("KnifePistolSpeedupMut:- Knife Replaced");
						}
					}
			}		
	}



	function KnifeFind(KFWeapon KFW, name ClassName)
	{
				//Replacing the knife, even if the perk is not supported
				KFIM.getWeaponfromclass(KFW, ClassName); //Checked
				if (KFW != None)
				{
					KnifeReplace(KFW,Classname);
					`log("KnifePistolSpeedupMut:- Knife is FOUND, Knife Perk: " $ Curclass);
				}
	}

	function KnifeReplace(KFWeapon KFW, name ClassName)
	{

			if(!IsSupportedPerk(KFP) && !KFIM.ClassIsInInventory(CurrentKnife,Inv) || SurvHasWrongKnife()) //Give perk knife
			{
				`log("****** KnifePistolSpeedupMut:- Unsupported Perk, Retrieving Supposed Knife ******");
				KFIM.getWeaponfromclass(KFWeapknife2Class, 'KnifeMut'); //Checked
				KFIM.RemoveFromInventory(KFW);
				KFIM.RemoveFromInventory(KFWeapknife2class);
				LogInternal("******* Custom Knife is Removed");	
				KFIM.CreateInventory(CurrentKnife, false);
				LogInternal("******* Current Perk Knife is Added");												
			}
			if(KFW != None && bSupportedPerk && !PlayerHasKnife()) //If you have found it, remove it (don't give it twice)
			{
				KFIM.RemoveFromInventory(KFW);
				LogInternal("******* Perk Knife is Removed");
				KFIM.CreateInventory(CurrentKnife, false);
				LogInternal("******* Custom Knife is Added");
			}

	}

	function bool PlayerHasKnife()
	{
			return KFIM.getWeaponfromclass(KFWeapknife2Class, 'KnifeMut');
	}

	function bool PlayerHasSurvKnife()
	{
			return KFIM.getWeaponfromclass(KFWeapknife2Class, 'KFPerk_Survivalist');
	}

	function bool SurvHasWrongKnife()
	{
		return PlayerHasKnife() && KFP.GetPerkClass() == class'KFPerk_Survivalist' && IsMeleeExpertActive();
	}

	function bool IsSupportedPerk(KFPerk CurPerk) //Checks if the perk supports the extra speed
	{
		//PerkClass is used to test different perks
		//CurPerk is the current perk obtained from the game
		if(Curperk != None)
		{
			CurClass = CurPerk.GetPerkClass(); //This gets <KFPerk>
			//Check if the current perk is one of the following perks
			PerkClass = class'KFPerk_Berserker'.static.GetPerkClass(); // Try Zerk
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=false;CurrentKnife=class'KFWeap_Knife_Berserker';return bSupportedPerk;}

			PerkClass = class'KFPerk_Commando'.static.GetPerkClass(); //Try Mandos
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=true;CurrentKnife=class'KnifeMut';return bSupportedPerk;}

			PerkClass = class'KFPerk_Support'.static.GetPerkClass(); //Try Support
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=true;CurrentKnife=class'KnifeMut';return bSupportedPerk;}

			PerkClass = class'KFPerk_FieldMedic'.static.GetPerkClass(); //Try Medic
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=false;CurrentKnife=class'KFWeap_Knife_FieldMedic';return bSupportedPerk;}

			PerkClass = class'KFPerk_Demolitionist'.static.GetPerkClass(); //Try Demo
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=true;CurrentKnife=class'KnifeMut';return bSupportedPerk;}

			PerkClass = class'KFPerk_Firebug'.static.GetPerkClass(); //Try Firebug
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=true;CurrentKnife=class'KnifeMut';return bSupportedPerk;}

			PerkClass = class'KFPerk_Gunslinger'.static.GetPerkClass(); //Try GS
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=false;CurrentKnife=class'KFWeap_Knife_Gunslinger';return bSupportedPerk;}

			PerkClass = class'KFPerk_Sharpshooter'.static.GetPerkClass(); //Try SS
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=true;CurrentKnife=class'KnifeMut';return bSupportedPerk;}

			PerkClass = class'KFPerk_Survivalist'.static.GetPerkClass(); //Try Surv
			if (Curclass.name == PerkClass.name)
				{
					if(IsMeleeExpertActive()){bSupportedPerk = false;CurrentKnife=class'KFWeap_Knife_Survivalist';}
					if(!IsMeleeExpertActive()){bSupportedPerk = true;CurrentKnife=class'KnifeMut';}
					`log("KnifePistolSpeedup:- Melee Expert is: "$ IsMeleeExpertActive());
					`log("KnifePistolSpeedup:- bsupposedperk is: "$ bSupportedPerk);
						return bSupportedPerk;
				}

			PerkClass = class'KFPerk_SWAT'.static.GetPerkClass(); //Try SWAT
			if (Curclass.name == PerkClass.name)
				{bSupportedPerk=true;CurrentKnife=class'KnifeMut';return bSupportedPerk;}

		}
	}

		function bool IsMeleeExpertActive()
	{
				if(KFPerk_Survivalist(KFP) != None)
					{KFSurv = KFPerk_Survivalist(KFP);return KFSurv.PerkSkills[ESurvivalist_MeleeExpert].bActive;}

 				else return false;
	}


	defaultproperties
	{
		KFWeapKnife2=class'KnifeMut'
	}