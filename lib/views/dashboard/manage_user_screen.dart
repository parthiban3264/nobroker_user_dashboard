import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noBroker_user_dashboard/app/routes.dart';
import 'package:noBroker_user_dashboard/core/constants/app_colors.dart';
import 'package:noBroker_user_dashboard/models/user_model.dart';
import 'package:noBroker_user_dashboard/view_models/user/user_event.dart';
import 'package:noBroker_user_dashboard/view_models/user/user_state.dart';

import '../../core/widgets/custom_loading.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../view_models/user/user_bloc.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserBloc>().add(GetAllUser());
    });
  }

  void _refreshUsers() {
    context.read<UserBloc>().add(GetAllUser());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.createUser);

          if (mounted) {
            _refreshUsers();
          }
        },
        backgroundColor: AppColors.primary1,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text(
          'Add User',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            /// Update Success
            if (state is UpdateUserSuccess) {
              Navigator.pop(context);

              CustomSnackBar.show(
                context,
                message: 'User Updated successful',
                type: SnackBarType.success,
                duration: Duration(milliseconds: 1000),
              );

              _refreshUsers();
            }

            /// Delete Success
            if (state is DeleteUserSuccess) {
              Navigator.pop(context);

              CustomSnackBar.show(
                context,
                message: 'User Deleted successful',
                type: SnackBarType.success,
                duration: Duration(milliseconds: 1000),
              );

              _refreshUsers();
            }

            /// Error
            if (state is UserError) {
              CustomSnackBar.show(
                context,
                message: state.msg,
                type: SnackBarType.error,
              );
            }
          },

          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(state),

                _buildSearch(),

                const SizedBox(height: 16),

                Expanded(child: _buildUserList(state)),

                const SizedBox(height: 80),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(UserState state) {
    int count = 0;

    if (state is UserSuccess) {
      count = state.users.length;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Users',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A32),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$count users available',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7A8580),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: _refreshUsers,
            icon: Icon(Icons.refresh_rounded, color: AppColors.primary1),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5EAE7)),
        ),
        child: TextField(
          controller: _searchController,

          onChanged: (value) {
            setState(() {
              _searchQuery = value.trim().toLowerCase();
            });
          },

          style: const TextStyle(fontSize: 14, color: Color(0xFF1D2A32)),

          decoration: InputDecoration(
            hintText: 'Search by name or email',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9AA39F)),

            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.primary1,
              size: 21,
            ),

            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();

                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 19,
                      color: Color(0xFF7A8580),
                    ),
                  )
                : null,

            border: InputBorder.none,

            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(UserState state) {
    /// Loading
    if (state is UserLoading) {
      return const CustomLoading(message: 'Loading users...');
    }

    /// Success
    if (state is UserSuccess) {
      final users = state.users;

      final filteredUsers = users.where((user) {
        final name = (user.name ?? '').toLowerCase();
        final email = (user.email ?? '').toLowerCase();

        return name.contains(_searchQuery) || email.contains(_searchQuery);
      }).toList();

      debugPrint('Total users: ${filteredUsers.length}');

      /// Empty
      if (filteredUsers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 55,
                color: Color(0xFFB0B8B4),
              ),

              const SizedBox(height: 12),

              Text(
                _searchQuery.isEmpty
                    ? 'No users found'
                    : 'No matching users found',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          _refreshUsers();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8ECEA)),
          ),

          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

            itemCount: filteredUsers.length,

            separatorBuilder: (_, _) {
              return const Divider(height: 1, color: Color(0xFFF0F2F1));
            },

            itemBuilder: (context, index) {
              final user = filteredUsers[index];

              return _UserTile(
                index: index + 1,
                name: user.name ?? '',
                email: user.email ?? '',
                status: user.status == true ? 'Active' : 'Inactive',

                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.updateUser,
                    arguments: {'users': user},
                  );
                },

                onDelete: () {
                  _showDeleteDialog(user);
                },
              );
            },
          ),
        ),
      );
    }
    return const SizedBox();
  }

  void _showDeleteDialog(UserModel user) {
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: !isDeleting,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: const Color(0xFFE55353).withValues(alpha: 0.10),

                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFE55353),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    'Delete User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              content: Text(
                'Are you sure you want to delete ${user.name}? '
                'This action cannot be undone.',
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),

              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },

                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE55353),

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: isDeleting
                      ? null
                      : () {
                          setDialogState(() {
                            isDeleting = true;
                          });

                          context.read<UserBloc>().add(DeleteUser(user));
                        },

                  child: isDeleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _UserTile extends StatelessWidget {
  final int index;
  final String name;
  final String email;
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserTile({
    required this.index,
    required this.name,
    required this.email,
    required this.status,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          /// Number Badge
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary1.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary1,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2A32),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7A8580),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// Status
          _StatusBadge(title: status, isActive: isActive),

          const SizedBox(width: 8),

          /// More Actions
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF7A8580)),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              }

              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: Color(0xFFE55353),
                    ),
                    SizedBox(width: 10),
                    Text('Delete', style: TextStyle(color: Color(0xFFE55353))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String title;
  final bool isActive;

  const _StatusBadge({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF2E7D4F) : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
