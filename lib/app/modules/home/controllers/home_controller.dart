import 'package:get/get.dart';
import 'package:movie_explorer_app/app/modules/Models/movie_models.dart';
import 'package:movie_explorer_app/app/modules/home/controllers/tmdb_service.dart';
import 'package:movie_explorer_app/app/modules/login/controllers/auth.dart';
import 'package:movie_explorer_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final TMDBService _tmdbService = TMDBService();

  final RxList<Movie> trendingMovies = <Movie>[].obs;
  final RxList<Movie> popularMovies = <Movie>[].obs;
  final RxList<int> savedMovieIds = <int>[].obs;
  final RxBool isLoading = false.obs;

  get currentUser => _authService.user;
  get isAuthenticated => _authService.isAuthenticated;

  @override
  void onInit() {
    super.onInit();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      isLoading.value = true;
      final trending = await _tmdbService.getTrendingMovies();
      final popular = await _tmdbService.getPopularMovies();
      
      trendingMovies.value = trending;
      popularMovies.value = popular;
    } catch (e) {
      print('Error loading movies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSaved(int movieId) {
    if (savedMovieIds.contains(movieId)) {
      savedMovieIds.remove(movieId);
    } else {
      savedMovieIds.add(movieId);
    }
  }

  bool isSaved(int movieId) => savedMovieIds.contains(movieId);

  Future<void> logout() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Logged Out',
        'See you again!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}