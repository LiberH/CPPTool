/**
 * generated by HARMLESS : 'Hardware ARchitecture Modeling Language
 *                          for Embedded Software Simulation'
 * model : e200z4
 *
 */

%module e200z4
%include typemaps.i
/* used to interprete correctly C++ string type.*/
%include "std_string.i"

%{
/* Includes the header in the wrapper code */
#include "arch.h"
#include "storage.h"
#include "instructionBase.h"
#include "stackController.h"
#include "stackSwitchList.h"
#include "stackList.h"
#include "codeReader.h"
%}

/* Parse the header file to generate wrappers */
%include "types.h"
%include "arch.h"
%include "storage.h"
%include "instructionBase.h"
%include "stackController.h"
%include "stackSwitchList.h"
%include "stackList.h"
%include "codeReader.h"
