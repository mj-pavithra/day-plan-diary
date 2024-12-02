import 'package:flutter/material.dart';

enum ViewState { Idle, Loading, Error , Success}
class BaseViewModel extends ChangeNotifier {

  String selectedPriority = 'All';
  bool isTodoSelected = true;
  int  taskcount= 0;

  ViewState _state = ViewState.Idle;
  String _errorMessage = '';

  ViewState get state => _state;

  String get errorMessage => _errorMessage;
  // ViewState get isLoading => _state == ViewState.Loading;

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setLoading() {
    setState(ViewState.Loading);
  }
  void setSuccess() {
    setState(ViewState.Success);
  }
    void setIdle() {
    setState(ViewState.Idle);
  }
  
  void setError(String errorMessage) {
    setErrorMessage(errorMessage);
    setState(ViewState.Error);

  }
  


}