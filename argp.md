# Header File #

```
#include <argp.h>
```

# Globals #

```
const char * argp_program_bug_address
```
> Should point to a string that will be printed at the end of the standard output for the '--help' option, embedded in a sentence that says 'Report bugs to _address_.'.

```
const char * argp_program_version
```
> Will add '--version' option when parsing with argp\_parse, and the defined string will be printed. Or set the _argp\_program\_version\_hook_ to a function which has the type signature as follow:

```
void print-version (FILE *stream, struct argp_state *state)
```

# The Parser #

```
struct argp_option
{
    // Long option, will have short option only if it is zero
    const char * name;

    // Key, and short option if it is a printable ASCII character
    int key;

    // The argument must be provided if it is non-zero,
    // unless the flag OPTION_ARG_OPTIONAL is set
    const char * arg;

    // OPTION_ARG_OPTIONAL - Argument is optional
    // OPTION_HIDDEN       - Not displayed in any help messages
    // OPTION_ALIAS        - An alias for the closest previous non-alias option
    //                       It will be displayed in the same help entry,
    //                       and will inherit fields other than name and key
    //                       from the option being aliased
    // OPTION_DOC          - Ignored by the actual option parser
    //                       No '--' prefix is added)
    //                       Displayed after all options in the same group,
    //                       after OPTION_DOC entries with a leading '-' 
    // OPTION_NO_USAGE     - Not included in 'long' usage messages,
    //                       but still be included in other help messages
    int flags;

    // Document string for the option
    // Trick: set both name and key to zero to print this as leading message of each group
    const char * doc;

    // Group identity for this option
    // Options are sorted alphabetically within each group,
    // and the groups presented in the order 0, 1, 2, ..., n, −m, ..., −2, −1.
    // Automagic options such as '--help' are put into group −1 
    int group;
};
```

```
struct argp
{
    // Vector of argp_option
    // Note: Need to end the vector with zero or it will lead to segmentation fault
    const struct argp_option * options;

    // Function that defines actions for this parser
    // Always return ARGP_ERR_UNKNOWN if it is set to NULL
    argp_parser_t parser;

    // Print the 'Usage:' message
    const char * args_doc;

    // Be printed before and after the options in a long help message,
    // with the two sections separated by a vertical tab ('\v', '\013') character
    const char * doc;

    // Vector of argp_child
    // Details can be found in the reference
    const struct argp_child * children;

    // Function that filters the output of help messages
    // Details can be found in the reference
    char *(* help_filter)(int key, const char * text, void * input);

    // Specify the argp domain
    // Details can be found in the reference
    const char * argp_domain;
};
```

# Example #

```
#include <argp.h>

const char * argp_program_bug_address = "<Lissy.Lau@gmail.com>";

struct AppOptions
{
    char        vmajor;
    char        vminor;
    std::string date;
    std::string inFile;
    bool        bCaseSensitive;
};

static AppOptions appOptions =
{
    1,                    // vmajor         (hard-coded)
    0,                    // vminor         (hard-coded)
    __DATE__" "__TIME__,  // date           (hard-coded)
    "",                   // inFile         (command-line settable)
    false                 // bCaseSensitive (command-line settable)
};

static struct argp_option appArgpOptions[] =
{
    {"inFile",        'i', "INPUT_FILE", 0, "Input file",     0},
    {"caseSensitive", 'c', NULL,         0, "Case sensitive", 0},
    {0}
};

static void printVersion
(
    FILE *              stream,
    struct argp_state * state __attribute__((unused))
)
{
    if (NULL != stream)
    {
        fprintf(stream, "%s v%d.%d %s\n", g_strAppName.c_str(),
                appOptions.vmajor, appOptions.vminor, appOptions.date.c_str());
    }
}

static error_t parseOpt
(
    int                 key,
    char *              arg,
    struct argp_state * state
)
{
    if (NULL == state)
    {
        return EINVAL;
    }

    AppOptions * arguments = static_cast<AppOptions *>(state->input);

    switch (key)
    {
        case 'i':
            arguments->inFile = arg;
            break;

        case 'c':
            arguments->bCaseSensitive = true;
            break;

        case ARGP_KEY_ARG:
            argp_error(state, "Too many arguments!");
            break;

        case ARGP_KEY_END:
            break;

        default:
            return ARGP_ERR_UNKNOWN;
    }

    return 0;
}

static struct argp argp = {appArgpOptions, parseOpt, "", "", 0, 0, 0};

int main(int argc, char ** argv)
{
    argp_program_version_hook = printVersion;

    if (argp_parse(&argp, argc, argv, 0, 0, &appOptions))
    {
        return -1;
    }

    // Do something with appOptions

    return 0;
}
```

# Reference #

  * [Argp - The GNU C Library](http://www.gnu.org/s/libc/manual/html_node/Argp.html)