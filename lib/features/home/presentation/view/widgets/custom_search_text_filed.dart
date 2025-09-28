import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_tracker_app/features/home/view_model/maps_cubit/maps_cubit.dart';

class CustomSearchTextFiled extends StatelessWidget {
  const CustomSearchTextFiled({super.key});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<MapsCubit>().textEditingController,
      onSubmitted: _onSubmit,
      onChanged: (value) async {},
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        hintText: 'Search a city',
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: const Icon(
          Icons.location_on,
          color: Colors.green,
          size: 32,
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.grey, size: 30),
        ),
        border: _borderStyle(),
        enabledBorder: _borderStyle(),
        focusedBorder: _borderStyle(),
      ),
    );
  }

  OutlineInputBorder _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );
  }

  void _onSubmit(String value) {}
}
