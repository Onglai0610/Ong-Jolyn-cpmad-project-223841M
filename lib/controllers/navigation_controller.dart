import 'package:get/get.dart';

// A controller to manage the navigation state for the bottom navigation bar.
class NavigationController extends GetxController {
  // The index of the currently selected page in the bottom navigation bar.
  var selectedIndex = 0.obs;

  // Updates the current selected page index.
  // [index] is the new index to be set.
  void changePage(int index) {
    selectedIndex.value = index;
  }
}
