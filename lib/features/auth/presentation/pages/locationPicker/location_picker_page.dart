import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/datasources/location_service.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? _tempLocation;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("حدد موقعك"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(33.5138, 36.2765),
              zoom: 12,
            ),
            onTap: (position) {
              setState(() => _tempLocation = position);
            },
            markers: _tempLocation == null
                ? {}
                : {
              Marker(
                markerId: const MarkerId('selected'),
                position: _tempLocation!,
              ),
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          )),
        ],
      ),
      floatingActionButton: _tempLocation == null
          ? null
          : FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          setState(() => _isLoading = true);

          String address = await LocationService.getAddressFromCoords(_tempLocation!);

          setState(() => _isLoading = false);

          if (mounted) {
            Navigator.pop(context, {
              'position': _tempLocation,
              'address': address,
            });
          }
        },
        label: const Text("تأكيد الموقع", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}