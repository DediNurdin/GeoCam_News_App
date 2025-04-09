import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_cam_news/features/geocam/bloc/geocam_bloc.dart';
import 'package:geo_cam_news/features/geocam/bloc/geocam_event.dart';
import 'package:geo_cam_news/features/geocam/bloc/geocam_state.dart';

class GeocamPage extends StatelessWidget {
  const GeocamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeocamBloc, GeocamState>(
      listener: (context, state) {
        if (state is GeocamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is GeocamLoaded && state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan!')),
          );
          context.read<GeocamBloc>().add(LoadGeocamData());
        }
      },
      builder: (context, state) {
        return BlocBuilder<GeocamBloc, GeocamState>(
          builder: (context, state) {
            if (state is GeocamInitial) {
              return _buildInitialState(context);
            } else if (state is GeocamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GeocamLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is GeocamError) {
              return _buildErrorState(context, state);
            } else if (state is GeocamSaving) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        );
      },
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            label: Text('Ambil Lokasi'),
            icon: Icon(Icons.location_on),
            onPressed: () {
              context.read<GeocamBloc>().add(GetLocation());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, GeocamLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lokasi Saat Ini',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Latitude: ${state.latitude?.toStringAsFixed(6) ?? 'Tidak tersedia'}',
                        ),
                        Text(
                          'Longitude: ${state.longitude?.toStringAsFixed(6) ?? 'Tidak tersedia'}',
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          _buildImagePreview(state.imagePath),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Visibility(
                visible: state.savedAt == null ? true : false,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Ambil Foto'),
                  onPressed: () {
                    context.read<GeocamBloc>().add(TakePhoto());
                  },
                ),
              ),
              Visibility(
                visible: state.savedAt == null ? false : true,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Reset Data',
                      style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                  ),
                  onPressed: () {
                    _showResetConfirmationDialog(context);
                  },
                ),
              ),
              if (state.imagePath != null && state.imagePath!.isNotEmpty)
                Visibility(
                  visible: state.savedAt == null ? true : false,
                  child: ElevatedButton.icon(
                    label: Text('Simpan Data',
                        style: TextStyle(
                            color: state.savedAt == null
                                ? Colors.green
                                : Colors.grey)),
                    icon: Icon(
                      Icons.save,
                      color: Colors.green,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[50],
                    ),
                    onPressed: () {
                      final currentState = context.read<GeocamBloc>().state;
                      if (currentState is GeocamLoaded &&
                          currentState.latitude != null &&
                          currentState.longitude != null &&
                          currentState.imagePath != null) {
                        context.read<GeocamBloc>().add(
                              SaveGeocamData(
                                latitude: currentState.latitude!,
                                longitude: currentState.longitude!,
                                imagePath: currentState.imagePath!,
                              ),
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Menyimpan data...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data belum lengkap!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Row(
        children: [
          Expanded(
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Belum ada foto yang diambil'),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }

    return FutureBuilder(
      future: File(imagePath).exists(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(imagePath),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorImageWidget();
              },
            ),
          );
        } else {
          return _buildErrorImageWidget();
        }
      },
    );
  }

  Widget _buildErrorImageWidget() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 10),
          Text('Gagal memuat gambar'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, GeocamError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            state.message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<GeocamBloc>().add(GetLocation());
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data'),
        content: const Text(
            'Apakah Anda yakin ingin menghapus data yang tersimpan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<GeocamBloc>().add(ResetData());
              Navigator.pop(context);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
