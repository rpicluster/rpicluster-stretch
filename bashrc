BASH(1)                                   General Commands Manual                                  BASH(1)

NNAAMMEE
       bash - GNU Bourne-Again SHell

SSYYNNOOPPSSIISS
       bbaasshh [options] [command_string | file]

CCOOPPYYRRIIGGHHTT
       Bash is Copyright (C) 1989-2013 by the Free Software Foundation, Inc.

DDEESSCCRRIIPPTTIIOONN
       BBaasshh is an sshh-compatible command language interpreter that executes commands read from the standard
       input or from a file.  BBaasshh also incorporates useful features from the _K_o_r_n and _C shells  (kksshh  and
       ccsshh).

       BBaasshh  is  intended to be a conformant implementation of the Shell and Utilities portion of the IEEE
       POSIX specification (IEEE Standard 1003.1).  BBaasshh can  be  configured  to  be  POSIX-conformant  by
       default.

OOPPTTIIOONNSS
       All of the  single-character shell options documented in the description of the sseett builtin command
       can be used as options when the shell is invoked.   In  addition,  bbaasshh  interprets  the  following
       options when it is invoked:

       --cc        If  the  --cc  option is present, then commands are read from the first non-option argument
                 _c_o_m_m_a_n_d___s_t_r_i_n_g.  If there are arguments after the _c_o_m_m_a_n_d___s_t_r_i_n_g, they  are  assigned  to
                 the positional parameters, starting with $$00.
       --ii        If the --ii option is present, the shell is _i_n_t_e_r_a_c_t_i_v_e.
       --ll        Make bbaasshh act as if it had been invoked as a login shell (see IINNVVOOCCAATTIIOONN below).
       --rr        If the --rr option is present, the shell becomes _r_e_s_t_r_i_c_t_e_d (see RREESSTTRRIICCTTEEDD SSHHEELLLL below).
       --ss        If the --ss option is present, or if no arguments remain after option processing, then com‐
                 mands are read from the standard input.  This option allows the positional parameters  to
                 be set when invoking an interactive shell.
       --DD        A  list  of  all  double-quoted  strings preceded by $$ is printed on the standard output.
                 These are the strings that are subject to language translation when the current locale is
                 not CC or PPOOSSIIXX.  This implies the --nn option; no commands will be executed.
       [[--++]]OO [[_s_h_o_p_t___o_p_t_i_o_n]]
                 _s_h_o_p_t___o_p_t_i_o_n is one of the shell options accepted by the sshhoopptt builtin (see SSHHEELLLL BBUUIILLTTIINN
                 CCOOMMMMAANNDDSS below).  If _s_h_o_p_t___o_p_t_i_o_n is present, --OO sets the value of that option; ++OO unsets
                 it.   If _s_h_o_p_t___o_p_t_i_o_n is not supplied, the names and values of the shell options accepted
                 by sshhoopptt are printed on the standard output.  If the invocation option is ++OO, the  output
                 is displayed in a format that may be reused as input.
       ----        A  ----  signals  the end of options and disables further option processing.  Any arguments
                 after the ---- are treated as filenames and arguments.  An argument of -- is  equivalent  to
                 ----.

       BBaasshh also interprets a number of multi-character options.  These options must appear on the command
       line before the single-character options to be recognized.

       ----ddeebbuuggggeerr
              Arrange for the debugger profile to be executed before the shell starts.  Turns on  extended
              debugging mode (see the description of the eexxttddeebbuugg option to the sshhoopptt builtin below).
       ----dduummpp--ppoo--ssttrriinnggss
              Equivalent to --DD, but the output is in the GNU _g_e_t_t_e_x_t ppoo (portable object) file format.
       ----dduummpp--ssttrriinnggss
              Equivalent to --DD.
       ----hheellpp Display a usage message on standard output and exit successfully.
       ----iinniitt--ffiillee _f_i_l_e
       ----rrccffiillee _f_i_l_e
              Execute  commands  from _f_i_l_e instead of the system wide initialization file _/_e_t_c_/_b_a_s_h_._b_a_s_h_r_c
              and the standard personal initialization file _~_/_._b_a_s_h_r_c if the  shell  is  interactive  (see
              IINNVVOOCCAATTIIOONN below).

       ----llooggiinn
              Equivalent to --ll.

       ----nnooeeddiittiinngg
              Do not use the GNU rreeaaddlliinnee library to read command lines when the shell is interactive.

       ----nnoopprrooffiillee
              Do not read either the system-wide startup file _/_e_t_c_/_p_r_o_f_i_l_e or any of the personal initial‐
              ization files _~_/_._b_a_s_h___p_r_o_f_i_l_e, _~_/_._b_a_s_h___l_o_g_i_n, or _~_/_._p_r_o_f_i_l_e.  By default, bbaasshh  reads  these
              files when it is invoked as a login shell (see IINNVVOOCCAATTIIOONN below).

       ----nnoorrcc Do  not  read  and execute the system wide initialization file _/_e_t_c_/_b_a_s_h_._b_a_s_h_r_c and the per‐
              sonal initialization file _~_/_._b_a_s_h_r_c if the shell is  interactive.   This  option  is  on  by
              default if the shell is invoked as sshh.

       ----ppoossiixx
              Change  the  behavior of bbaasshh where the default operation differs from the POSIX standard to
              match the standard (_p_o_s_i_x _m_o_d_e).  See SSEEEE AALLSSOO below for a  reference  to  a  document  that
              details how posix mode affects bash's behavior.

       ----rreessttrriicctteedd
              The shell becomes restricted (see RREESSTTRRIICCTTEEDD SSHHEELLLL below).

       ----vveerrbboossee
              Equivalent to  --vv.

       ----vveerrssiioonn
              Show  version information for this instance of bbaasshh on the standard output and exit success‐
              fully.

AARRGGUUMMEENNTTSS
       If arguments remain after option processing, and neither the --cc nor the --ss  option  has  been  sup‐
       plied,  the  first argument is assumed to be the name of a file containing shell commands.  If bbaasshh
       is invoked in this fashion, $$00 is set to the name of the file, and the  positional  parameters  are
       set  to  the  remaining  arguments.   BBaasshh  reads and executes commands from this file, then exits.
       BBaasshh's exit status is the exit status of the last command executed in the script.  If  no  commands
       are  executed,  the  exit  status  is  0.  An attempt is first made to open the file in the current
       directory, and, if no file is found, then the shell  searches  the  directories  in  PPAATTHH  for  the
       script.

IINNVVOOCCAATTIIOONN
       A _l_o_g_i_n _s_h_e_l_l is one whose first character of argument zero is a --, or one started with the ----llooggiinn
       option.

       An _i_n_t_e_r_a_c_t_i_v_e shell is one started without non-option arguments and without the  --cc  option  whose
       standard  input  and  error  are  both  connected to terminals (as determined by _i_s_a_t_t_y(3)), or one
       started with the --ii option.  PPSS11 is set and $$-- includes ii if bbaasshh is interactive, allowing a  shell
       script or a startup file to test this state.

       The  following  paragraphs describe how bbaasshh executes its startup files.  If any of the files exist
       but cannot be read, bbaasshh reports an error.  Tildes are expanded in  filenames  as  described  below
       under TTiillddee EExxppaannssiioonn in the EEXXPPAANNSSIIOONN section.

       When  bbaasshh is invoked as an interactive login shell, or as a non-interactive shell with the ----llooggiinn
       option, it first reads and executes commands from the  file  _/_e_t_c_/_p_r_o_f_i_l_e,  if  that  file  exists.
       After  reading  that  file,  it  looks  for _~_/_._b_a_s_h___p_r_o_f_i_l_e, _~_/_._b_a_s_h___l_o_g_i_n, and _~_/_._p_r_o_f_i_l_e, in that
       order, and reads and executes commands from the  first  one  that  exists  and  is  readable.   The
       ----nnoopprrooffiillee option may be used when the shell is started to inhibit this behavior.

       When  a  login  shell  exits,  bbaasshh reads and executes commands from the file _~_/_._b_a_s_h___l_o_g_o_u_t, if it
       exists.

       When an interactive shell that is not a login shell is started, bbaasshh reads  and  executes  commands
       from  _/_e_t_c_/_b_a_s_h_._b_a_s_h_r_c  and  _~_/_._b_a_s_h_r_c,  if  these files exist.  This may be inhibited by using the
       ----nnoorrcc option.  The ----rrccffiillee _f_i_l_e option will force bbaasshh to read and  execute  commands  from  _f_i_l_e
       instead of _/_e_t_c_/_b_a_s_h_._b_a_s_h_r_c and _~_/_._b_a_s_h_r_c.

       When  bbaasshh is started non-interactively, to run a shell script, for example, it looks for the vari‐
       able BBAASSHH__EENNVV in the environment, expands its value if it appears  there,  and  uses  the  expanded
       value  as  the  name  of a file to read and execute.  BBaasshh behaves as if the following command were
       executed:
              if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi
       but the value of the PPAATTHH variable is not used to search for the filename.

       If bbaasshh is invoked with the name sshh, it tries to mimic the startup behavior of historical  versions
       of  sshh  as closely as possible, while conforming to the POSIX standard as well.  When invoked as an
       interactive login shell, or a non-interactive shell with the ----llooggiinn option, it first  attempts  to
       read  and execute commands from _/_e_t_c_/_p_r_o_f_i_l_e and _~_/_._p_r_o_f_i_l_e, in that order.  The ----nnoopprrooffiillee option
       may be used to inhibit this behavior.  When invoked as an interactive shell with the name sshh,  bbaasshh
       looks  for the variable EENNVV, expands its value if it is defined, and uses the expanded value as the
       name of a file to read and execute.  Since a shell invoked as sshh does not attempt to read and  exe‐
       cute  commands  from any other startup files, the ----rrccffiillee option has no effect.  A non-interactive
       shell invoked with the name sshh does not attempt to read any other startup files.  When  invoked  as
       sshh, bbaasshh enters _p_o_s_i_x mode after the startup files are read.

       When  bbaasshh  is started in _p_o_s_i_x mode, as with the ----ppoossiixx command line option, it follows the POSIX
       standard for startup files.  In this mode, interactive shells expand the EENNVV variable and  commands
       are  read  and executed from the file whose name is the expanded value.  No other startup files are
       read.

       BBaasshh attempts to determine when it is being run with its standard input connected to a network con‐
       nection,  as  when  executed  by  the remote shell daemon, usually _r_s_h_d, or the secure shell daemon
       _s_s_h_d.  If bbaasshh determines it is being run in this fashion, it  reads  and  executes  commands  from
       _~_/_._b_a_s_h_r_c  and _~_/_._b_a_s_h_r_c, if these files exist and are readable.  It will not do this if invoked as
       sshh.  The ----nnoorrcc option may be used to inhibit this behavior, and the ----rrccffiillee option may be used to
       force  another  file  to  be  read, but neither _r_s_h_d nor _s_s_h_d generally invoke the shell with those
       options or allow them to be specified.

       If the shell is started with the effective user (group) id not equal to the real user  (group)  id,
       and  the  --pp  option  is not supplied, no startup files are read, shell functions are not inherited
       from the environment, the SSHHEELLLLOOPPTTSS, BBAASSHHOOPPTTSS, CCDDPPAATTHH, and GGLLOOBBIIGGNNOORREE variables, if they appear  in
       the  environment,  are  ignored,  and  the effective user id is set to the real user id.  If the --pp
       option is supplied at invocation, the startup behavior is the same, but the effective  user  id  is
       not reset.

DDEEFFIINNIITTIIOONNSS
       The following definitions are used throughout the rest of this document.
       bbllaannkk  A space or tab.
       wwoorrdd   A sequence of characters considered as a single unit by the shell.  Also known as a ttookkeenn.
       nnaammee   A  _w_o_r_d  consisting  only  of alphanumeric characters and underscores, and beginning with an
              alphabetic character or an underscore.  Also referred to as an iiddeennttiiffiieerr.
       mmeettaacchhaarraacctteerr
              A character that, when unquoted, separates words.  One of the following:
              ||  && ;; (( )) << >> ssppaaccee ttaabb
       ccoonnttrrooll ooppeerraattoorr
              A _t_o_k_e_n that performs a control function.  It is one of the following symbols:
              |||| && &&&& ;; ;;;; (( )) || ||&& <<nneewwlliinnee>>

RREESSEERRVVEEDD WWOORRDDSS
       _R_e_s_e_r_v_e_d _w_o_r_d_s are words that have a special meaning to the shell.  The following words are  recog‐
       nized  as  reserved  when unquoted and either the first word of a simple command (see SSHHEELLLL GGRRAAMMMMAARR
       below) or the third word of a ccaassee or ffoorr command:

       !! ccaassee  ccoopprroocc  ddoo ddoonnee eelliiff eellssee eessaacc ffii ffoorr ffuunnccttiioonn iiff iinn sseelleecctt tthheenn uunnttiill wwhhiillee {{ }} ttiimmee [[[[ ]]]]

SSHHEELLLL GGRRAAMMMMAARR
   SSiimmppllee CCoommmmaannddss
       A _s_i_m_p_l_e _c_o_m_m_a_n_d is a sequence of optional variable assignments followed by  bbllaannkk-separated  words
       and redirections, and terminated by a _c_o_n_t_r_o_l _o_p_e_r_a_t_o_r.  The first word specifies the command to be
       executed, and is passed as argument zero.  The remaining words  are  passed  as  arguments  to  the
       invoked command.

       The  return  value of a _s_i_m_p_l_e _c_o_m_m_a_n_d is its exit status, or 128+_n if the command is terminated by
       signal _n.

   PPiippeelliinneess
       A _p_i_p_e_l_i_n_e is a sequence of one or more commands separated by one of the control operators || or ||&&.
       The format for a pipeline is:

              [ttiimmee [--pp]] [ ! ] _c_o_m_m_a_n_d [ [||⎪||&&] _c_o_m_m_a_n_d_2 ... ]

       The  standard  output  of  _c_o_m_m_a_n_d is connected via a pipe to the standard input of _c_o_m_m_a_n_d_2.  This
       connection is performed before any redirections specified by the command (see  RREEDDIIRREECCTTIIOONN  below).
       If  ||&&  is used, _c_o_m_m_a_n_d's standard error, in addition to its standard output, is connected to _c_o_m_‐
       _m_a_n_d_2's standard input through the pipe; it is shorthand for 22>>&&11 ||.  This implicit redirection  of
       the standard error to the standard output is performed after any redirections specified by the com�