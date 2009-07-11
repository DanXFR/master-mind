///////////////////////////////////////////////////////////////////////////////
/// @file FrequencyAnalyzer_Main.cpp
/// @brief Main Entrance of FrequencyAnalyzer (CLI-based)
///
/// Related Files:
///
/// Copyright (C) 2009 Lissy Lau
///
/// MasterMind is free software: you can redistribute it and / or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// This program is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with this program.  If not, see <http://www.gnu.org/licenses/>.
///////////////////////////////////////////////////////////////////////////////

#include <fstream>
#include <iostream>
#include <iomanip>
#include <vector>
#include <argp.h>
#include "CharFrequency.h"

static const std::string g_strAppName = "MasterMind Frequency Analyzer";
const char * argp_program_bug_address = "<Lissy.Lau@gmail.com>";

// Hard-coded and settable configuration options
struct AppOptions
{
    char        vmajor;
    char        vminor;
    std::string date;
    std::string inFile;
    bool        bSorted;
    bool        bCaseSensitive;
    bool        bSkipWS;
};

static AppOptions appOptions =
{
    1,                    // vmajor         (hard-coded)
    0,                    // vminor         (hard-coded)
    __DATE__" "__TIME__,  // date           (hard-coded)
    "",                   // inFile         (command-line settable)
    false,                // bSorted        (command-line settable)
    false,                // bCaseSensitive (command-line settable)
    false                 // bSkipWS        (command-line settable)
};

static struct argp_option appArgpOptions[] =
{
    {"inFile",        'i', "INPUT_FILE", 0, "Input file",         0},
    {"sort",          's', NULL,         0, "Sort the output",    0},
    {"caseSensitive", 'c', NULL,         0, "Case sensitive",     0},
    {"wsSkipped",     'w', NULL,         0, "Whitespace skipped", 0},
    {0}
};

///////////////////////////////////////////////////////////////////////////////
/// @brief Print the version of the application
///
/// @param[in] stream - FILE stream destination of the output
/// @param[in] state  - Unused
///
/// @returns - None
///////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////
/// @brief Parse the command line options
///
/// @param[in] key   - The key referring to the command line argument
/// @param[in] arg   - The value of the current command line argument
/// @param[in] state - Used to get the current argument setting
///
/// @returns - An error indication (EINVAL) or 0 on success
///////////////////////////////////////////////////////////////////////////////
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

        case 's':
            arguments->bSorted = true;
            break;

        case 'c':
            arguments->bCaseSensitive = true;
            break;

        case 'w':
            arguments->bSkipWS = true;
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
    // Or set the argp_program_version
    argp_program_version_hook = printVersion;

    if (argp_parse(&argp, argc, argv, 0, 0, &appOptions))
    {
        return -1;
    }

    std::ifstream inFile;
    CharFrequency freqChar;

    inFile.open(appOptions.inFile.c_str());
    freqChar.process(inFile, appOptions.bSkipWS, appOptions.bCaseSensitive);
    inFile.close();

    // Display the result

    std::vector<std::pair<unsigned int, unsigned char> > vMap;
    std::vector<std::pair<unsigned int, unsigned char> >::const_iterator iter;

    freqChar.getAlnum(vMap, appOptions.bSorted);

    std::cout << std::endl;

    unsigned int cntAlnum   = freqChar.getAlnum();
    unsigned int cntPunct   = freqChar.getPunct();
    unsigned int cntSpace   = freqChar.getSpace();
    unsigned int cntPrint   = freqChar.getPrint();
    unsigned int cntCtrl    = freqChar.getCtrl();
    unsigned int cntUnknown = freqChar.getUnknown();

    if (0 != cntPrint)
    {
        for (iter = vMap.begin(); iter != vMap.end(); iter++)
        {
            std::cout << "[" << iter->second << "] " << std::setw(5) << iter->first;
            std::cout << std::setw(5) << (iter->first * 100) / cntPrint << "%" << std::endl;
        }
        std::cout << std::endl;
    }
    
    std::cout << "Alphanumeric Characters:    " << std::setw(5) << cntAlnum;
    if (0 != cntPrint)
    {
        std::cout << std::setw(5) << (cntAlnum * 100) / cntPrint << "%";
    }
    std::cout << std::endl;

    std::cout << "Punctuation Characters:     " << std::setw(5) << cntPunct;
    if (0 != cntPrint)
    {
        std::cout << std::setw(5) << (cntPunct * 100) / cntPrint << "%";
    }
    std::cout << std::endl;

    std::cout << "Whitespace Characters:      " << std::setw(5) << cntSpace;
    if (0 != cntPrint)
    {
        std::cout << std::setw(5) << (cntSpace * 100) / cntPrint << "%";
    }
    std::cout << std::endl;

    std::cout << "Total Printable Characters: " << std::setw(5) << cntPrint;
    if (0 != cntPrint)
    {
        std::cout << std::setw(5) << (cntPrint * 100) / cntPrint << "%";
    }
    std::cout << std::endl;

    std::cout << std::endl;

    std::cout << "Control Characters:         " << std::setw(5) << cntCtrl << std::endl;
    std::cout << std::endl;

    std::cout << "Unknown Characters:         " << std::setw(5) << cntUnknown << std::endl;
    std::cout << std::endl;

    /// @todo Character Frequency Statistics

    return 0;
}
