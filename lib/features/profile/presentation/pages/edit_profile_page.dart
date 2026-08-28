import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_log/core/extensions/localization_extension.dart';
import 'package:lift_log/core/extensions/theme_extension.dart';
import 'package:lift_log/core/helpers/validators.dart';
import 'package:lift_log/core/models/user_model.dart';
import 'package:lift_log/core/theme/app_spacing.dart';
import 'package:lift_log/core/utils/app_enums.dart';
import 'package:lift_log/core/widgets/app_button.dart';
import 'package:lift_log/core/widgets/app_labeled_text_field.dart';
import 'package:lift_log/core/widgets/app_picker_field.dart';
import 'package:lift_log/core/widgets/app_scaffold.dart';
import 'package:lift_log/core/widgets/app_snackbar.dart';
import 'package:lift_log/core/widgets/app_text_field.dart';
import 'package:lift_log/features/profile/cubit/edit_profile_cubit.dart';
import 'package:lift_log/features/profile/cubit/edit_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(user: widget.user),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            AppSnackbar.success(
              message: 'profile_updated'.tr,
              context: context,
            );
            context.pop(true);
          }

          if (state is EditProfileFailure) {
            AppSnackbar.error(message: state.message, context: context);
          }
        },
        builder: (context, state) {
          final formState = state is EditProfileInitial ? state : null;
          final isSaving = formState?.isSaving ?? false;

          return AppScaffold(
            appBar: AppBar(title: Text('edit_profile'.tr)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    LabeledTextField(
                      label: 'full_name'.tr,
                      child: AppTextField(
                        controller: _nameController,
                        hint: 'full_name'.tr,
                        filled: true,
                        validator: Validators.name,
                        onChanged: context.read<EditProfileCubit>().setName,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppPickerField<int>(
                            label: 'age'.tr,
                            hint: 'select'.tr,
                            value: formState?.age,
                            fillColor:
                                context.theme.inputDecorationTheme.fillColor,
                            validator: (value) => Validators.age(value),
                            onTap: () => context
                                .read<EditProfileCubit>()
                                .openAgePicker(context),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppPickerField<Gender>(
                            label: 'gender'.tr,
                            hint: 'select'.tr,
                            value: formState?.gender != null
                                ? Gender.values.firstWhere(
                                    (g) => g.name == formState!.gender,
                                    orElse: () => Gender.male,
                                  )
                                : null,
                            fillColor:
                                context.theme.inputDecorationTheme.fillColor,
                            displayText: (g) =>
                                g.name[0].toUpperCase() + g.name.substring(1),
                            validator: (value) => Validators.gender(value),
                            onTap: () => context
                                .read<EditProfileCubit>()
                                .openGenderPicker(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppPickerField<double>(
                            label: 'height'.tr,
                            hint: 'select'.tr,
                            value: formState?.height,
                            fillColor:
                                context.theme.inputDecorationTheme.fillColor,
                            displayText: (h) => '${h.toInt()} cm',
                            validator: (value) => Validators.height(value),
                            onTap: () => context
                                .read<EditProfileCubit>()
                                .openHeightPicker(context),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppPickerField<double>(
                            label: 'weight'.tr,
                            hint: 'select'.tr,
                            value: formState?.weight,
                            fillColor:
                                context.theme.inputDecorationTheme.fillColor,
                            displayText: (w) => '${w.toInt()} kg',
                            validator: (value) => Validators.weight(value),
                            onTap: () => context
                                .read<EditProfileCubit>()
                                .openWeightPicker(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xl),
                    AppButton(
                      title: 'save',
                      loading: isSaving,
                      onPressed: isSaving
                          ? null
                          : () => context.read<EditProfileCubit>().save(
                              formKey: _formKey,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
