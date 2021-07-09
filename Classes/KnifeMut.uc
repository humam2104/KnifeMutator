class KnifeMut extends KFWeap_Edged_Knife;
function InitializeAmmo()
{
	MovementSpeedMod = class'KnifePistolSpeedupMut'.default.MovespeedMulitplier;
	ParryDamageMitigationPercent = class'KnifePistolSpeedupMut'.default.ParryBlockMultiplier;
	BlockDamageMitigation = class'KnifePistolSpeedupMut'.default.ParryBlockMultiplier;
}
defaultproperties
{
	// Zooming/Position
	PlayerViewOffset=(X=10,Y=10,Z=0)

	// Content
	PackageKey="FireBug_Knife"
	FirstPersonMeshName="WEP_1P_FireBug_Knife_MESH.Wep_1stP_FirebugKnife_Rig"
	AttachmentArchetypeName="WEP_FireBug_Knife_ARCH.Wep_FirebugKnife_3P"

	Begin Object Name=FirstPersonMesh
		AnimSets(0)=AnimSet'WEP_1P_CommandoKnife_ANIM.Wep_1stP_CommKnife_Anim'
	End Object

	// Inventory
	AssociatedPerkClasses(0)=class'KFPerk_Berserker'
	AssociatedPerkClasses(1)=class'KFPerk_Commando'
	AssociatedPerkClasses(2)=class'KFPerk_Support'
	AssociatedPerkClasses(3)=class'KFPerk_FieldMedic'
	AssociatedPerkClasses(4)=class'KFPerk_Demolitionist'
	AssociatedPerkClasses(5)=class'KFPerk_Firebug'
	AssociatedPerkClasses(6)=class'KFPerk_Gunslinger'
	AssociatedPerkClasses(7)=class'KFPerk_Sharpshooter'
	AssociatedPerkClasses(8)=class'KFPerk_Survivalist'
	AssociatedPerkClasses(9)=class'KFPerk_SWAT'
	WeaponSelectTexture=Texture2D'WEP_UI_Firebug_Knife_TEX.UI_WeaponSelect_FirebugKnife'


}