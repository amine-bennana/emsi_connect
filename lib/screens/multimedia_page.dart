import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

// ── TP5-2 : Page Multimédia avec l'ensemble des Exercices Bonus ───────────────

class MultimediaPage extends StatefulWidget {
  const MultimediaPage({super.key});

  @override
  State<MultimediaPage> createState() => _MultimediaPageState();
}

class _MultimediaPageState extends State<MultimediaPage> {
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  XFile? _image;
  int? _imageBytes; // Bonus 2 : taille du fichier image
  String? _audioPath;
  bool _recording = false;
  bool _busy = false;

  // Bonus 3 : Compteur de durée d'enregistrement
  Timer? _recordTimer;
  int _recordDurationSeconds = 0;

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Bonus 2 : Formatage lisible de la taille en octets
  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} Mo ($bytes octets)';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} Ko ($bytes octets)';
    }
    return '$bytes octets';
  }

  // Bonus 3 : Formatage du temps en mm:ss
  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Sélection ou capture d'image avec lecture de métadonnées (Bonus 2) ─────
  Future<void> _chooseImage(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final XFile? selected = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );
      if (!mounted) return;
      if (selected == null) {
        _message('Sélection annulée.');
      } else {
        // Calcul asynchrone de la taille en octets
        final length = await selected.length();
        if (!mounted) return;
        setState(() {
          _image = selected;
          _imageBytes = length;
        });
        _message('Image chargée (${_formatBytes(length)})');
      }
    } catch (e) {
      _message('Impossible de récupérer l’image : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ── Bonus 1 : Effacer l'image sélectionnée ─────────────────────────────────
  void _clearImage() {
    setState(() {
      _image = null;
      _imageBytes = null;
    });
    _message('Image effacée.');
  }

  // ── Démarrage de l'enregistrement avec timer et gestion permanente (Bonus 3 & 5) ──
  Future<void> _startRecording() async {
    if (_busy || _recording) return;
    setState(() => _busy = true);
    try {
      // Bonus 5 : Gestion du refus définitif avec bouton vers openAppSettings()
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final status = await Permission.microphone.request();
        if (status.isPermanentlyDenied) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Permission microphone définitivement refusée.',
              ),
              action: SnackBarAction(
                label: 'Paramètres',
                textColor: Colors.amber,
                onPressed: () => openAppSettings(),
              ),
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        } else if (!status.isGranted) {
          _message('Microphone non autorisé.');
          return;
        }
      }

      if (!await _recorder.hasPermission()) {
        _message('Autorisation microphone indisponible.');
        return;
      }

      if (kIsWeb) {
        _message('Enregistrement à tester sur Android/iOS.');
        return;
      }

      final path = '${Directory.systemTemp.path}/question_emsi.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      // Bonus 3 : Démarrage du compteur de durée
      _recordDurationSeconds = 0;
      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordDurationSeconds++;
          });
        }
      });

      if (mounted) setState(() => _recording = true);
    } catch (e) {
      _message('Enregistrement impossible : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ── Arrêt de l'enregistrement ─────────────────────────────────────────────
  Future<void> _stopRecording() async {
    if (!_recording) return;
    _recordTimer?.cancel();
    try {
      final path = await _recorder.stop();
      if (!mounted) return;
      setState(() {
        _recording = false;
        _audioPath = path;
      });
      _message(path == null
          ? 'Aucun fichier enregistré.'
          : 'Question vocale enregistrée (${_formatDuration(_recordDurationSeconds)}).');
    } catch (e) {
      _message('Erreur lors de l’arrêt : $e');
      if (mounted) setState(() => _recording = false);
    }
  }

  // ── Lecture du fichier audio ──────────────────────────────────────────────
  Future<void> _playAudio() async {
    if (_audioPath == null) return;
    try {
      await _player.stop();
      await _player.play(DeviceFileSource(_audioPath!));
    } catch (e) {
      _message('Lecture impossible : $e');
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Bonus 4 : PopScope pour empêcher de quitter accidentellement pendant l'enregistrement
    return PopScope(
      canPop: !_recording,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldStopAndExit = await showDialog<bool>(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            title: const Text('Enregistrement en cours'),
            content: const Text(
              'Un enregistrement audio est actuellement en cours. Voulez-vous l’arrêter et quitter la page ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx, false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(dialogCtx, true),
                child: const Text('Arrêter et quitter'),
              ),
            ],
          ),
        );

        if (shouldStopAndExit == true) {
          await _stopRecording();
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Espace multimédia',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Section 1 : Images & Métadonnées ──────────────────────────
            Text(
              'Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed:
                      _busy ? null : () => _chooseImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Prendre une photo'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed:
                      _busy ? null : () => _chooseImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galerie'),
                ),
                // Bonus 1 : Bouton Effacer l'image
                if (_image != null)
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: _busy ? null : _clearImage,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Effacer l’image'),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Affichage de l'image sélectionnée
            if (_image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(_image!.path, height: 190, fit: BoxFit.cover)
                    : Image.file(File(_image!.path),
                        height: 190, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),

              // Bonus 2 : Nom et taille du fichier en octets
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 20, color: Colors.green.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nom : ${_image!.name}\nTaille : ${_imageBytes != null ? _formatBytes(_imageBytes!) : "Inconnue"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 40),

            // ── Section 2 : Audio & Enregistrement ─────────────────────────
            Text(
              'Question vocale',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 12),

            // Bonus 3 : Compteur de durée d'enregistrement en direct
            if (_recording)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fiber_manual_record,
                        color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Enregistrement en cours... ${_formatDuration(_recordDurationSeconds)}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

            // Bouton enregistrer / arrêter
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _recording ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _busy
                  ? null
                  : (_recording ? _stopRecording : _startRecording),
              icon: Icon(_recording ? Icons.stop : Icons.mic),
              label: Text(_recording ? 'Arrêter' : 'Enregistrer'),
            ),

            if (_audioPath != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal.shade700,
                  side: BorderSide(color: Colors.teal.shade700),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _playAudio,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Écouter l’enregistrement'),
              ),
            ],

            if (_busy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
