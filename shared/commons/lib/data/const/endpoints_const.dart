abstract class AppEndpoints {

  //https://guardian-gate.kindrock-da55ab0b.eastus.azurecontainerapps.io
  static const String GuardianGate = 'https://guardian-gate.kindrock-da55ab0b.eastus.azurecontainerapps.io';
  static const String GuardianGateUserSignIn = '$GuardianGate/User/signin';
  static const String GuardianGateUserSignUp = '$GuardianGate/User/signup';
  static const String GuardianGateUserGetUser = '$GuardianGate/User/getuser';


  //https://campaign-forge.kindrock-da55ab0b.eastus.azurecontainerapps.io
  static const String CampaignForge = 'https://campaign-forge.kindrock-da55ab0b.eastus.azurecontainerapps.io';
  static const String CampaignForgeCampaignGetCampaignsByIdManager = '$CampaignForge/Poll/getpollsbymanager';
  static const String CampaignForgeCampaignCreateCampaign = '$CampaignForge/Poll/createpoll';
  static const String CampaignForgeCampaignUpdateCampaign = '$CampaignForge/Poll/updatepoll';
  static const String CampaignForgeCampaignDeleteCampaign = '$CampaignForge/Poll/deletepoll/';

  //https://stat-mosaic.kindrock-da55ab0b.eastus.azurecontainerapps.io
  static const String StatMosaic = 'https://stat-mosaic.kindrock-da55ab0b.eastus.azurecontainerapps.io';
  static const String StatMosaicStatistics = '$StatMosaic/Statistics';
}