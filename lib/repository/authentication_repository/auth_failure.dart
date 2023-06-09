class SignInWithEmailAndPasswordFailure {
  final String message;

  const SignInWithEmailAndPasswordFailure([this.message = "An unknown error occured."]);

  factory SignInWithEmailAndPasswordFailure.code(String code){
    switch (code) {
      case 'weak-password': 
        return const SignInWithEmailAndPasswordFailure("Veuillez entrer un mot de passe plus fort.");
      case 'invalid-email': 
        return const SignInWithEmailAndPasswordFailure("L'email n'est pas valide.");
      case 'email-already-in-use': 
        return const SignInWithEmailAndPasswordFailure("Un compte existe déjà pour cet adresse mail.");
      case 'operation-not-allowed': 
        return const SignInWithEmailAndPasswordFailure("Cette opération n'est pas valide.");
      case 'user-disabled': 
        return const SignInWithEmailAndPasswordFailure("Cet utilisateur a été supprimé. Veuillez contacter le support.");
      default: return const SignInWithEmailAndPasswordFailure();
    }
  }
}