import 'package:project_tpm/models/place.dart';
import 'package:project_tpm/network/base_network.dart';

abstract class PlaceView{
  void showLoading();
  void hideLoading();
  void showBudayaPlaceCategory(List<PlaceModel> placeCategoryList);
  void showAlamPlaceCategory(List<PlaceModel> placeCategoryList);
  void showTamanPlaceCategory(List<PlaceModel> placeCategoryList);
  void showError(String message);
}

class PlacePresenter {
  final PlaceView view;
  PlacePresenter(this.view);

  Future<void> loadPlaceBudayaData() async {
    try {
      final Map<String, dynamic> response = await BaseNetwork.getDataByCategory("Budaya");
      print("Response Budaya: $response");

      final List<dynamic> data = response['data']; // ambil field 'data'
      final placeList = data.map((json) => PlaceModel.fromJson(json)).toList();
      
      view.showBudayaPlaceCategory(placeList);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }

  Future<void> loadPlaceAlamData() async {
    try{
      final Map<String, dynamic> response = await BaseNetwork.getDataByCategory("Cagar Alam");
      final List<dynamic> data = response['data']; // ambil field 'data'
      final placeList = data.map((json)=>PlaceModel.fromJson(json)).toList();
      view.showAlamPlaceCategory(placeList);
    }catch(e){
      view.showError(e.toString());
    }finally{
      view.hideLoading();
    }
  }

  Future<void> loadPlaceTamanData() async {
    try{
      final Map<String, dynamic> response = await BaseNetwork.getDataByCategory("Taman Hiburan");
      final List<dynamic> data = response['data']; // ambil field 'data'
      final placeList = data.map((json)=>PlaceModel.fromJson(json)).toList();
      view.showTamanPlaceCategory(placeList);
    }catch(e){
      view.showError(e.toString());
    }finally{
      view.hideLoading();
    }
  }
}