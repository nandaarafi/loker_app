import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lokerapps/features/data/history_remote_data_source.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  final HistoryRemoteDataSource remoteDataSource;
  ImageCubit(this.remoteDataSource) : super(ImageInitial());

  Future<void> fetchImages({
      required bucketName
  } ) async {
    try {
      emit(ImageLoading());

      final List<String> imageUrls = await remoteDataSource.fetchImages(bucketName: bucketName);
      if (imageUrls.isEmpty) {
        emit(ImageNoData('Tidak ada data gambar di $bucketName'));
      } else {
        emit(ImageLoaded(imageUrls));
      }
    } catch (e) {
      emit(ImageError('Failed to load images: $e'));
    }
  }
}
