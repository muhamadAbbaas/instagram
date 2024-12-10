// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/local/cash_helper.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String fullName,
    required String email,
    required String userName,
    required String password,
  }) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      emit(SignUpSuccessState());
      setUserData(
        fullName: fullName,
        email: email,
        userName: userName,
        uId: value.user!.uid,
      );
    }).catchError((onError) {
      print(onError);
      emit(SignUpErrorState());
    });
  }

  void setUserData({
    required String fullName,
    required String email,
    required String userName,
    required String uId,
  }) {
    UserModel userModel = UserModel(
      fullName: fullName,
      email: email,
      userName: userName,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('userInfo')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(SetUserDataSuccessState());
    }).catchError((error) {
      print(error);
      emit(SetUserDataErrorState());
    });
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessState(uId: value.user!.uid));
    }).catchError(
      (error) {
        print(error);
        emit(LoginErrorState(error: error));
      },
    );
  }

  Future<void> logout() async {
    FirebaseAuth.instance
        .signOut()
        .then(
          (value) {
            emit(LogoutSuccessState());
            CacheHelper.deleteData(key: 'uId');
          },
        )
        .catchError(
      (error) {
        emit(state);
        print(LogoutErrorState());
      },
    );
  }
}
