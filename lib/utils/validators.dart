// ── Partie Bonus (TP4) : Fonction utilitaire réutilisable pour valider les champs ─

class Validators {
  // Expression régulière robuste pour valider les adresses email
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  // Expression régulière pour un numéro de téléphone marocain (10 chiffres, ex: 0612345678 ou +212612345678)
  static final RegExp _phoneRegex = RegExp(r'^(?:0|\+212)[5-7]\d{8}$');

  /// Valide une adresse email
  static String? validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) {
      return 'Email obligatoire';
    }
    if (!_emailRegex.hasMatch(email)) {
      return 'Format d\'email invalide (ex: exemple@emsi.ma)';
    }
    return null;
  }

  /// Valide un mot de passe (au moins 8 caractères)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe obligatoire';
    }
    if (value.length < 8) {
      return 'Au moins 8 caractères';
    }
    return null;
  }

  /// Valide un numéro de téléphone (Bonus 1)
  static String? validatePhone(String? value) {
    final phone = (value ?? '').replaceAll(RegExp(r'\s+'), '');
    if (phone.isEmpty) {
      return 'Numéro de téléphone obligatoire';
    }
    if (!_phoneRegex.hasMatch(phone)) {
      return 'Numéro invalide (ex: 0612345678)';
    }
    return null;
  }

  /// Valide un champ obligatoire générique
  static String? validateRequired(String? value, String nomDuChamp) {
    if (value == null || value.trim().isEmpty) {
      return '$nomDuChamp obligatoire';
    }
    return null;
  }
}

