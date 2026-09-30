import 'package:e_commerce_admin/core/router/app_routes.dart';
import 'package:e_commerce_admin/features/users/cubit/user_cubit.dart';
import 'package:e_commerce_admin/features/users/cubit/user_state.dart';
import 'package:e_commerce_admin/features/users/data/models/admin_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    super.key,
  });

  @override
  State<UsersScreen> createState() =>
      _UsersScreenState();
}

class _UsersScreenState
    extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersCubit>().getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {
          if (state is UsersError) {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar();

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
                behavior:
                    SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (state is UsersDeleting) {
            return _UsersContent(
              users: state.users,
              deletingUserId: state.userId,
              isLoading: true,
            );
          }

          if (state is UsersCreating) {
            return _UsersContent(
              users: state.users,
              deletingUserId: null,
              isLoading: true,
            );
          }

          if (state is UsersSuccess) {
            return _UsersContent(
              users: state.users,
              deletingUserId: null,
              isLoading: false,
            );
          }

          if (state is UsersError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<UsersCubit>()
                    .getAllUsers();
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _UsersContent extends StatelessWidget {
  final List<AdminUserModel> users;
  final String? deletingUserId;
  final bool isLoading;

  const _UsersContent({
    required this.users,
    required this.deletingUserId,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: users.isEmpty
              ? const _EmptyUsers()
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(24),
                  child: _UsersTable(
                    users: users,
                    deletingUserId:
                        deletingUserId,
                    isLoading: isLoading,
                  ),
                ),
        ),

        // =========================
        // CREATE USER BUTTON
        // =========================

        Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            24,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.push(
                        AppRoutes.createUser,
                      );
                    },
              icon: const Icon(
                Icons.person_add_outlined,
              ),
              label: const Text(
                'Create User',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UsersTable extends StatelessWidget {
  final List<AdminUserModel> users;
  final String? deletingUserId;
  final bool isLoading;

  const _UsersTable({
    required this.users,
    required this.deletingUserId,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'All Users (${users.length})',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: DataTable(
                columnSpacing: 28,
                headingRowHeight: 56,
                dataRowMinHeight: 65,
                dataRowMaxHeight: 75,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'UID',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Phone',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Role',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    numeric: true,
                    label: Text(
                      'Orders',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: users.map((user) {
                  final isDeleting =
                      deletingUserId ==
                          user.uid;

                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 160,
                          child: Text(
                            user.name.isEmpty
                                ? '—'
                                : user.name,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        SizedBox(
                          width: 180,
                          child: SelectableText(
                            user.uid,
                            style:
                                const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Text(
                            user.email.isEmpty
                                ? '—'
                                : user.email,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        SizedBox(
                          width: 140,
                          child: Text(
                            user.phone.isEmpty
                                ? '—'
                                : user.phone,
                          ),
                        ),
                      ),

                      DataCell(
                        _RoleBadge(
                          role: user.role,
                        ),
                      ),

                      DataCell(
                        Text(
                          user.ordersCount
                              .toString(),
                        ),
                      ),

                      DataCell(
                        IconButton(
                          tooltip:
                              'Delete User',
                          onPressed: isLoading
                              ? null
                              : () {
                                  _showDeleteDialog(
                                    context,
                                    user,
                                  );
                                },
                          icon: isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                  ),
                                )
                              : const Icon(
                                  Icons
                                      .delete_outline,
                                ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AdminUserModel user,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete User',
          ),
          content: Text(
            'Are you sure you want to delete '
            '${user.name.isEmpty ? user.email : user.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                context
                    .read<UsersCubit>()
                    .deleteUser(
                      user.uid,
                    );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        color: isAdmin
            ? Colors.orange.withValues(
                alpha: 0.12,
              )
            : Colors.blue.withValues(
                alpha: 0.12,
              ),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isAdmin
              ? Colors.orange.shade800
              : Colors.blue.shade800,
        ),
      ),
    );
  }
}

class _EmptyUsers extends StatelessWidget {
  const _EmptyUsers();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No users found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first user.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}