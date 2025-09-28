import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_tracker_app/features/home/view_model/maps_cubit/maps_cubit.dart';
import 'package:route_tracker_app/features/home/view_model/maps_cubit/maps_states.dart';

class ResultsListView extends StatelessWidget {
  const ResultsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: BlocBuilder<MapsCubit, MapsStates>(
        buildWhen: (previous, current) => current is ClearSuggestedPlaces,
        builder: (context, state) {
          return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final place = cubit.places[index];
              return ListTile(
                onTap: () async {
                  await cubit.getPlaceDetails(placeId: place.placeId);
                },
                leading: const Icon(Icons.location_on),
                title: Text(place.placeName),
                subtitle: Text(place.address),
                trailing: const Icon(Icons.arrow_outward_outlined),
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemCount: cubit.places.length,
          );
        },
      ),
    );
  }
}
