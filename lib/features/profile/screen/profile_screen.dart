import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/route_constants.dart';
import 'package:gurme/common/widgets/loading_spinner.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/item/screen/item_screen.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/models/comment_model.dart';
import 'package:gurme/models/company_model.dart';
import 'package:gurme/models/item_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String _id;
  const ProfileScreen({super.key, required String id}) : _id = id;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  final _scrollControllerNestedView = ScrollController();
  final _scrollControllerTabViewComments = ScrollController();
  final _scrollControllerTabViewFavorites = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerNestedView.dispose();
    _scrollControllerTabViewComments.dispose();
    _scrollControllerTabViewFavorites.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ref.watch(getUserByIdProvider(widget._id)).when(
          data: (user) {
            return Scaffold(
              body: NestedScrollView(
                controller: _scrollControllerNestedView,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    elevation: 0,
                    collapsedHeight: 60,
                    toolbarHeight: 60,
                    expandedHeight: 150,
                    pinned: true,
                    automaticallyImplyLeading: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        // scroll offset to 0.0 - 1.0
                        final double ratio =
                            (_scrollControllerNestedView.offset /
                                    (150 - kToolbarHeight))
                                .clamp(0, 1);

                        print(screenWidth);
                        print(screenHeight);

                        // sliverappbar color animation
                        final backgroundColor = Color.lerp(
                          const Color(0xFFCFD3ED).withOpacity(0.00),
                          const Color(0xFFCFD3ED).withOpacity(1),
                          ratio,
                        );

                        // profile pic animation
                        final imageRadius = 80 - (25 * ratio);
                        final imagePositionBottom =
                            (-55 - ((screenHeight - 760) * 0.1)) - (20 * ratio);
                        final imagePositionLeft = (screenWidth * 0.5 - 80) -
                            ((screenWidth * 0.5 - 100) * ratio);

                        // icon animation
                        final iconPositionBottom = 50 - (50 * ratio);
                        final iconPositionLeft = (screenWidth * 0.5 + 40) +
                            ((screenWidth * 0.4 - 55) * ratio);

                        // name animation
                        final namePositionBottom = -110 + (65 * ratio);
                        final namePositionLeft = (screenWidth * 0.5) +
                            ((screenWidth * 0.1 + 10) * ratio);

                        return Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                user.bannerPic,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: backgroundColor,
                              ),
                            ),
                            Positioned(
                              bottom: namePositionBottom,
                              left: namePositionLeft,
                              child: FractionalTranslation(
                                translation: const Offset(-0.45, 0),
                                child: SizedBox(
                                  width: screenWidth * 0.60,
                                  child: Text(
                                    user.name,
                                    style: GoogleFonts.inter(
                                      fontSize:
                                          32 + ((screenWidth - 393) * 0.1),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: imagePositionBottom,
                              left: imagePositionLeft,
                              child: Container(
                                height: imageRadius * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFCFD3ED),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    user.profilePic,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            ref.read(userProvider.notifier).state!.uid ==
                                    widget._id
                                ? Positioned(
                                    bottom: iconPositionBottom,
                                    left: iconPositionLeft,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withOpacity(1 - ratio),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Colors.black.withOpacity(
                                                0.25 - 0.25 * ratio),
                                            offset: const Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: IconButton(
                                        iconSize: 30,
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                  SliverAppBar(
                    backgroundColor: Theme.of(context).canvasColor,
                    expandedHeight: 100,
                    collapsedHeight: 100,
                    toolbarHeight: 100,
                    pinned: true,
                    elevation: 0,
                    title: const SizedBox(height: 100),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        isScrollable: false,
                        indicatorColor: Colors.indigo.shade400,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        tabs: ["Yorumlar", "Favoriler"]
                            .map(
                              (category) => Tab(
                                text: category,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    pinned: true,
                  ),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ref.watch(getCommentsOfUserProvider(widget._id)).when(
                          data: (commentData) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              itemCount: commentData.comments.length,
                              itemBuilder: (context, index) {
                                final comment = commentData.comments[index];
                                final item = commentData.items[index];
                                return CommentTileCompany(
                                  comment: comment,
                                  item: item,
                                );
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            return Text(error.toString());
                          },
                          loading: () => const LoadingSpinner(
                            height: 50,
                            width: 50,
                          ),
                        ),
                    ref
                        .watch(
                          getFavoriteCompaniesProvider(user.favoriteCompanyIds),
                        )
                        .when(
                          data: (companies) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              itemCount: companies.length,
                              itemBuilder: (context, index) {
                                final company = companies[index];
                                return FavoriteTileCompany(
                                  company: company,
                                  ref: ref,
                                  userId: widget._id,
                                );
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            return Text(error.toString());
                          },
                          loading: () => const LoadingSpinner(
                            height: 50,
                            width: 50,
                          ),
                        )
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Scaffold(
            body: Center(
              child: LoadingSpinner(
                width: 75,
                height: 75,
              ),
            ),
          ),
        );
  }
}

class CommentTileCompany extends StatelessWidget {
  final Comment comment;
  final Item item;
  const CommentTileCompany(
      {super.key, required this.comment, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 1,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.indigo.shade400.withOpacity(0.06),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    showPopUpScreen(
                      context: context,
                      builder: (context) {
                        return CommentBottomSheet(
                          comment: comment,
                        );
                      },
                    );
                  },
                  child: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: () {
                              showPopUpScreen(
                                context: context,
                                builder: (context) {
                                  return ItemScreen(
                                    item: item,
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: Colors.grey.shade200,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: Image.network(
                                  item.picture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.companyName} - ${item.name}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                comment.rating,
                                (index) => const Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                ),
                                child: SizedBox(
                                  child: Text(
                                    comment.text!,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    softWrap: true,
                                  ),
                                ),
                              ),
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
        ],
      ),
    );
  }
}

class FavoriteTileCompany extends StatelessWidget {
  final Company company;
  final WidgetRef ref;
  final String userId;
  const FavoriteTileCompany(
      {super.key,
      required this.company,
      required this.ref,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 1,
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.indigo.shade400.withOpacity(0.06),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteConstants.companyScreen,
                      pathParameters: {"id": company.id},
                    );
                  },
                  child: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: Image.network(
                                company.bannerPic,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 2),
                                Text(
                                  company.rating.toStringAsFixed(1),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.grade_rounded,
                                  size: 18,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  company.ratingCount.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            if (ref.read(userProvider.notifier).state!.uid ==
                                userId) {
                              await ref
                                  .read(profileControllerProvider.notifier)
                                  .removeFromFavorites(userId, company.id);
                            }
                          },
                          icon: const Icon(Icons.favorite_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Theme.of(context).canvasColor),
        color: Theme.of(context).canvasColor,
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
