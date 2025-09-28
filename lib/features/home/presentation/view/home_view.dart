import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/features/home/presentation/view/widgets/custom_search_text_filed.dart';
import 'package:route_tracker_app/features/home/presentation/view/widgets/results_list_view.dart';
import 'package:route_tracker_app/features/home/view_model/maps_cubit/maps_cubit.dart';
import 'package:route_tracker_app/features/home/view_model/maps_cubit/maps_states.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<MapsCubit, MapsStates>(
              buildWhen: (previous, current) =>
                  current is AddDestinationPolygon || current is ChangeMapView,
              builder: (context, state) {
                return GoogleMap(
                  zoomControlsEnabled: false,
                  polylines: cubit.mapPolylines,
                  markers: cubit.mapMarkers,
                  onMapCreated: (controller) {
                    cubit.googleMapController = controller;
                    cubit.navigateToUserLocation();
                  },
                  initialCameraPosition: cubit.initialCameraPotion,
                );
              },
            ),
            const Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  CustomSearchTextFiled(),
                  SizedBox(height: 5),
                  ResultsListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
