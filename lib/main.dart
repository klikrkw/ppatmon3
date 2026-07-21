import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_bloc.dart';
import 'package:newklikrkw/blocs/berkas_lokasi/berkas_lokasi_bloc.dart';
import 'package:newklikrkw/blocs/biayaperm/biayaperm_bloc.dart';
import 'package:newklikrkw/blocs/bukubesar/bukubesar_bloc.dart';
import 'package:newklikrkw/blocs/home/home_bloc.dart';
import 'package:newklikrkw/blocs/item/item_bloc.dart';
import 'package:newklikrkw/blocs/item/item_event.dart';
import 'package:newklikrkw/blocs/kasbon/kasbon_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/neraca/neraca_bloc.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_bloc.dart';
import 'package:newklikrkw/blocs/theme/theme_bloc.dart';
import 'package:newklikrkw/blocs/theme/theme_state.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_bloc.dart';
import 'package:newklikrkw/core/theme/app_theme.dart';
import 'package:newklikrkw/models/product_model.dart';
import 'package:newklikrkw/pages/login_page.dart';
import 'package:newklikrkw/repositories/auth_repository.dart';
import 'package:newklikrkw/repositories/bayarbiayaperm_repository.dart';
import 'package:newklikrkw/repositories/berkas_lokasi_repository.dart';
import 'package:newklikrkw/repositories/biayaperm_repository.dart';
import 'package:newklikrkw/repositories/bukubesar_repository.dart';
import 'package:newklikrkw/repositories/database_repository.dart';
import 'package:newklikrkw/repositories/home_repository.dart';
import 'package:newklikrkw/repositories/keluarbiaya_repository.dart';
import 'package:newklikrkw/repositories/keluarbiayapermuser_repository.dart';
import 'package:newklikrkw/repositories/neraca_repository.dart';
import 'package:newklikrkw/repositories/postingjurnal_repository.dart';
import 'package:newklikrkw/repositories/prosespermohonan_repository.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/routes.dart';
import 'package:newklikrkw/screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:newklikrkw/services/bayarbiayaperm.dart';
import 'package:newklikrkw/services/berkas_lokasi_service.dart';
import 'package:newklikrkw/services/biayaperm_service.dart';
import 'package:newklikrkw/services/bukubesar_service.dart';
import 'package:newklikrkw/services/home_service.dart';
import 'package:newklikrkw/services/kasbon_service.dart';
import 'package:newklikrkw/services/keluarbiaya_service.dart';
import 'package:newklikrkw/services/keluarbiayapermuser_service.dart';
import 'package:newklikrkw/services/neraca_service.dart';
import 'package:newklikrkw/services/postingjurnal_service.dart';
import 'package:newklikrkw/services/prosespermohonan_service.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final authRepository = AuthRepository();
  final kasbonService = KasbonService();
  final berkaslokasiService = BerkasLokasiService();
  final transpermohonanService = TranspermohonanService();
  final prosespermohonanService = ProsespermohonanService();
  final biayapermService = BiayapermService();
  final berkasLokasiRepository = BerkasLokasiRepository(berkaslokasiService);
  final bayarbiayapermService = BayarbiayapermService();
  final keluarbiayaService = KeluarbiayaService();

  await initializeDateFormatting('id_ID', null);
  runApp(
    MyApp(
      authRepository: authRepository,
      kasbonService: kasbonService,
      transpermohonanService: transpermohonanService,
      prosespermohonanService: prosespermohonanService,
      biayapermService: biayapermService,
      berkasLokasiRepository: berkasLokasiRepository,
      bayarbiayapermService: bayarbiayapermService,
      keluarbiayaService: keluarbiayaService,
      keluarbiayapermuserService: KeluarbiayapermuserService(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthRepository authRepository;
  final KasbonService kasbonService;
  final TranspermohonanService transpermohonanService;
  final ProsespermohonanService prosespermohonanService;
  final BiayapermService biayapermService;
  final BerkasLokasiRepository berkasLokasiRepository;
  final BayarbiayapermService bayarbiayapermService;
  final KeluarbiayaService keluarbiayaService;
  final KeluarbiayapermuserService keluarbiayapermuserService;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.kasbonService,
    required this.transpermohonanService,
    required this.prosespermohonanService,
    required this.berkasLokasiRepository,
    required this.biayapermService,
    required this.bayarbiayapermService,
    required this.keluarbiayaService,
    required this.keluarbiayapermuserService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    // print('ready in 3...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 2...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 1...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DatabaseRepository<Product>>(
          create: (context) => ProductRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ItemBloc<Product>>(
            create: (context) => ItemBloc<Product>(
              repository: context.read<DatabaseRepository<Product>>(),
            )..add(FetchItemsEvent()), // Pemicu fetch data pertama kali
          ),
          BlocProvider(
            create: (_) => TranspermohonanBloc(
              TranspermohonanRepository(widget.transpermohonanService),
            ),
          ),
          BlocProvider(
            create: (_) => ProsespermohonanBloc(
              ProsespermohonanRepository(widget.prosespermohonanService),
            ),
          ),
          BlocProvider(
            create: (_) =>
                BiayapermBloc(BiayapermRepository(widget.biayapermService)),
          ),
          BlocProvider(
            create: (_) => BayarbiayapermBloc(
              repository: BayarbiayapermRepository(
                service: widget.bayarbiayapermService,
              ),
            ),
          ),
          BlocProvider(
            create: (_) => KeluarbiayaBloc(
              repository: KeluarbiayaRepository(widget.keluarbiayaService),
            ),
          ),
          BlocProvider(
            create: (_) => KeluarbiayapermuserBloc(
              repository: KeluarbiayapermuserRepository(
                widget.keluarbiayapermuserService,
              ),
            ),
          ),
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: widget.authRepository)
                  ..add(AppStarted()),
          ),
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(
            create: (context) =>
                KasbonBloc(kasbonService: widget.kasbonService)
                  ..add(NewKasbon()),
          ),
          BlocProvider(
            create: (_) => BerkasLokasiBloc(widget.berkasLokasiRepository),
          ),
          BlocProvider(
            create: (_) => BukubesarBloc(
              repository: BukubesarRepository(service: BukubesarService()),
            ),
          ),
          BlocProvider(
            create: (_) => NeracaBloc(
              repository: NeracaRepository(service: NeracaService()),
            ),
          ),
          BlocProvider(
            create: (_) => PostingjurnalBloc(
              repository: PostingjurnalRepository(
                service: PostingjurnalService(),
              ),
            ),
          ),
          BlocProvider(create: (_) => HomeBloc(HomeRepository(HomeService()))),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Monitoring App',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              routes: routes,
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return const HomeScreen();
                  }
                  if (state is Unauthenticated || state is AuthFailure) {
                    return LoginPage();
                  }

                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              supportedLocales: [
                const Locale('id', ''), // Indonesia
                const Locale('en', ''), // Inggris
              ],
            );
          },
        ),
      ),
    );
  }
}
