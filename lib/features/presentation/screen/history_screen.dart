import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokerapps/core/constants/colors.dart';
import 'package:lokerapps/core/routes/constants.dart';
import 'package:lokerapps/core/routes/routes.dart';

import '../cubit/image/image_cubit.dart';

class HistoryScreen extends StatefulWidget {
  final String bucketName;
  
  HistoryScreen({required this.bucketName});

  @override
  State<StatefulWidget> createState() => _HistoryScreenState();

}

class _HistoryScreenState extends State<HistoryScreen>{

  @override
  void initState() {
    context.read<ImageCubit>().fetchImages(bucketName: widget.bucketName);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LColors.secondary,
        leading: IconButton(onPressed: () {
        AppRouter.router.go(Routes.controlScreenNamedPage);
      }, icon: Icon(Icons.arrow_back,
        color: Colors.white)
          )
        ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: BlocBuilder<ImageCubit, ImageState>(
          builder: (context, state) {
            if (state is ImageInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ImageLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ImageLoaded) {
              return ListView.builder(
                itemCount: state.images.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return Image.network(state.images[index],
                  width: 150,
                  height: 150,);
                },
              );
            }
            else if (state is ImageNoData) {
              return Center(child: Text(state.message, style: TextStyle(fontSize: 18)));
            } else if (state is ImageError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
  }