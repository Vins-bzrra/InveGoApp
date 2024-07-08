enum Urls{

  RegisterIT('http://10.0.0.107:8080/inveGo/api/it-item/register'),
  RegisterFurniture('http://10.0.0.107:8080/inveGo/api/furniture-item/register'),
  RegisterOthers('http://10.0.0.107:8080/inveGo/api/others-item/register'),

  SearchIT('http://10.0.0.107:8080/inveGo/api/it-item/search'),
  SearchFurniture('http://10.0.0.107:8080/inveGo/api/furniture-item/search'),
  SearchOthers('http://10.0.0.107:8080/inveGo/api/others-item/search'),

  TranferFurniture('http:10.0.0.107:8080/inveGo/api/furniture-item/transfer'),
  TransferIT('http://10.0.0.107:8080/inveGo/api/it-item/transfer'),
  TransferOthers('http://10.0.0.107:8080/inveGo/api/others-item/transfer'),

  UpdateFurniture('http:10.0.0.107:8080/inveGo/api/furniture-item/update'),
  UpdateIT('http://10.0.0.107:8080/inveGo/api/it-item/update'),
  UpdateOthers('http://10.0.0.107:8080/inveGo/api/others-item/update'),

  DisposedIT('http://10.0.0.107:8080/api/it-item/disposed'),
  DisposedFurniture('http://10.0.0.107:8080/api/furniture-item/disposed'),
  DisposedOthers('http://10.0.0.107:8080/api/others-item/disposed'),

  RegisterUser('http://10.0.0.107:8080/inveGo/api/users/register'),
  SearchUsers('http://10.0.0.107:8080/inveGo/api/users/search'),
  DeleteUser('http://10.0.0.107:8080/inveGo/api/users/delete'),
  ResetPassword('http://10.0.0.107:8080/inveGo/api/users/reset-password'),

  ItemITDetails('http://10.0.0.107:8080/inveGo/api/it-item/id'),
  ItemFurnitureDetails('http://10.0.0.107:8080/inveGo/api/furniture-item/id'),
  ItemOthersDetails('http://10.0.0.107:8080/inveGo/api/others-item/id'),

  AcquisitionRegister('http://10.0.0.107:8080/inveGo/api/item/acquisition');

  final String value;
  const Urls(this.value);
}