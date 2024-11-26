part of 'image_cubit.dart';

abstract class ImageState extends Equatable {
  const ImageState();
  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState{}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final List<String> images;

  ImageLoaded(this.images);

  @override
  List<Object> get props => [images];
}

class ImageError extends ImageState {
  final String message;

  ImageError(this.message);

  @override
  List<Object> get props => [message];
}

class ImageNoData extends ImageState {
  final String message;

  ImageNoData(this.message);

  @override
  List<Object> get props => [message];
}
