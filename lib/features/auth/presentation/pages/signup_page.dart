import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/constants.dart';
import '../../../../core/router/route_constants.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_password_field.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    useEffect(() {
      final sub = ref.listenManual<AuthState>(authNotifierProvider, (previous, next) {
        if (next is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(next.message)),
            );
        }

        if (next is AuthAuthenticated) {
          context.go(RouteConstants.notes.toPath);
        }
      });

      return sub.close;
    }, const []);

    void submit() {
      if (!(formKey.currentState?.validate() ?? false)) return;

      final email = emailController.text.trim();
      final password = passwordController.text;

      ref.read(authNotifierProvider.notifier).signUp(
            email: email,
            password: password,
          );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: Constants.paddingAllMedium,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Sign up',
                          style: textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Space.verticalLarge,
                    AuthEmailField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                    ),
                    Space.verticalMedium,
                    AuthPasswordField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => submit(),
                    ),
                    Space.verticalMedium,
                    AuthPrimaryButton(
                      label: 'Create account',
                      isLoading: isLoading,
                      onPressed: submit,
                    ),
                    Space.verticalMedium,
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.go(RouteConstants.login.toPath),
                      child: Text(
                        'Already have an account? Login',
                        style: textTheme.labelLarge,
                      ),
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
