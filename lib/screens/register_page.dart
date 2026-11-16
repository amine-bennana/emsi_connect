import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/validators.dart';

// ── TP4 : Inscription et fonctionnalités Bonus (1, 2, 3, 4) ────────────────────
// - Bonus 1 : Champ téléphone avec clavier numérique et validation
// - Bonus 2 : Compteur de caractères pour un champ de description (maxLength)
// - Bonus 3 : Utilisation des fonctions utilitaires réutilisables Validators
// - Bonus 4 : Bascule dynamique de thème clair / sombre

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(); // Bonus 1
  final _bioController = TextEditingController(); // Bonus 2
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text('Formulaire valide — compte non créé'),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        centerTitle: true,
        actions: [
          // ── Bonus 4 : Bouton de bascule thème clair / sombre ─────────────
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Mode clair' : 'Mode sombre',
            onPressed: () {
              MyApp.themeModeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      // Encadrement adaptatif : SafeArea, SingleChildScrollView, Center, ConstrainedBox (Partie 6)
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Créer un compte',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Remplissez les informations ci-dessous pour vous inscrire',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── 1. Champ Nom complet ────────────────────────────────
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nom complet',
                        hintText: 'ex: Mohamed Alami',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          Validators.validateRequired(value, 'Nom complet'),
                    ),
                    const SizedBox(height: 16),

                    // ── 2. Champ Adresse email (Bonus 3) ────────────────────
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Adresse email',
                        hintText: 'exemple@emsi.ma',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // ── 3. Champ Téléphone avec clavier numérique (Bonus 1) ──
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Numéro de téléphone',
                        hintText: 'ex: 0612345678',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: Validators.validatePhone,
                    ),
                    const SizedBox(height: 16),

                    // ── 4. Champ Description avec compteur (Bonus 2) ────────
                    TextFormField(
                      controller: _bioController,
                      maxLines: 3,
                      maxLength: 150, // Active le compteur de caractères x/150
                      decoration: const InputDecoration(
                        labelText: 'Biographie / Description',
                        hintText: 'Parlez brièvement de votre profil...',
                        prefixIcon: Icon(Icons.notes),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── 5. Champ Mot de passe ───────────────────────────────
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 16),

                    // ── 6. Champ Confirmation avec test de concordance ───────
                    TextFormField(
                      controller: _confirmController,
                      obscureText: !_showConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirmation du mot de passe',
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirm = !_showConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirmez votre mot de passe';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // ── Bouton « Créer mon compte » ─────────────────────────
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Créer mon compte',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Lien retour vers Connexion ──────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Déjà inscrit ?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Se connecter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
