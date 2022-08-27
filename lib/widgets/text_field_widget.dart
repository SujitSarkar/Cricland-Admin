import 'package:cricland_admin/constants/static_colors.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/dynamic_size.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({Key? key,
    required this.controller,
    this.labelText,
    this.onTap,
    this.obscure=false,
    this.readOnly=false,
    this.textInputType,
    this.textCapitalization,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLine,
    this.minLine,
    this.suffixOnTap,this.prefixOnTap}) : super(key: key);

  final TextEditingController controller;
  final String? labelText;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscure;
  final bool readOnly;
  final int? maxLine;
  final int? minLine;
  final Function()? onTap;
  final Function()? suffixOnTap;
  final Function()? prefixOnTap;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _obscure=true;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return TextField(
      controller: widget.controller,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      obscureText: widget.obscure? _obscure:false,
      keyboardType: widget.textInputType??TextInputType.text,
      textCapitalization: widget.textCapitalization??TextCapitalization.none,
      maxLines: widget.maxLine??1,
      minLines: widget.minLine??1,
      onEditingComplete: (){},
      style: TextStyle(
        color: StaticColor.textColor,
        fontWeight: FontWeight.w500,
        fontSize: dynamicSize(.022)
      ),
      decoration: InputDecoration(
          alignLabelWithHint: true,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: StaticColor.primaryColor,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color:StaticColor.primaryColor,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: StaticColor.primaryColor,width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal:15,
              vertical: 15),
          hintText: widget.labelText,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: StaticColor.hintColor,
            fontSize: dynamicSize(.02),
            fontFamily: 'openSans',
            fontWeight: FontWeight.w400
          ),
          hintStyle: TextStyle(
              color: StaticColor.hintColor,
              fontSize: dynamicSize(.02),
              fontFamily: 'openSans',
              fontWeight: FontWeight.w400
          ),
          prefixIcon: widget.prefixIcon!=null?InkWell(
            onTap: widget.prefixOnTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 8,left: 8),
              child: Icon(widget.prefixIcon,size: dynamicSize(0.03),
                  color: Colors.grey.shade600),
            ),
          ):null,
          suffixIconConstraints: BoxConstraints.loose(size),
          prefixIconConstraints: BoxConstraints.loose(size),
          suffixIcon: widget.obscure
              ? InkWell(
            onTap: ()=>setState(()=> _obscure=!_obscure),
            child: Padding(
              padding: const EdgeInsets.only(right:10),
              child: Icon(_obscure?LineAwesomeIcons.eye_slash:LineAwesomeIcons.eye,
                  size: dynamicSize(0.03),
                  color: Colors.grey.shade600),
            ),
          ) : widget.suffixIcon!=null
              ?InkWell(
            onTap: widget.suffixOnTap,
            child: Padding(
              padding: const EdgeInsets.only(right:8),
              child: Icon(widget.suffixIcon, size: dynamicSize(.03),
                  color: Colors.grey.shade600),
            ),
          ) :null
      ),
    );
  }
}
