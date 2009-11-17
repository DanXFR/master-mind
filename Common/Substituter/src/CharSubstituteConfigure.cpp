///////////////////////////////////////////////////////////////////////////////
/// @file CharSubstituteConfigure.cpp
/// @brief Character Substitution Configuration Class of MasterMind.
///
/// Related Files:
/// @li CharSubstituteConfigure.h - Declaration
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

#include <ctype.h>
#include <string.h>
#include <fstream>
#include <locale>
#include "CharSubstituteConfigure.h"

const std::string CharSubstituteConfigure::m_Name = "Character Substitution Configuration";

CharSubstituteConfigure::~CharSubstituteConfigure()
{
}

CharSubstituteConfigure::CharSubstituteConfigure
(
    std::string scheme_,
    bool bCaseSensitive_,
    bool bKeepOriginal_,
    unsigned char unknownSymbol_
)
{
    // Initialization
    for (int i = 0; i < 256; i++)
    {
        if (isprint((unsigned char)i))
        {
            if (!bKeepOriginal_)
            {
                m_Data[i] = unknownSymbol_;
            }
            else
            {
                m_Data[i] = (unsigned char)i;
            }
        }
        else
        {
            m_Data[i] = (unsigned char)i;
        }
    }

    std::ifstream inFile;

    inFile.open(scheme_.c_str());

    unsigned char originChar, newChar;

    while (EOF != inFile.peek())
    {
        // By default, whitespace will be ignored
        inFile >> originChar >> newChar;

        if (bCaseSensitive_)
        {
            m_Data[(int)originChar] = newChar;
        }
        else
        {
            m_Data[(int)std::toupper(originChar)] = std::toupper(newChar);
            m_Data[(int)std::tolower(originChar)] = std::tolower(newChar);
        }
    }

    inFile.close();

    /// @todo More validation is needed.
}

CharSubstituteConfigure::CharSubstituteConfigure(const CharSubstituteConfigure &obj_)
{
    memcpy(m_Data, obj_.m_Data, 256);
}

CharSubstituteConfigure & CharSubstituteConfigure::operator =(const CharSubstituteConfigure &obj_)
{
    memcpy(m_Data, obj_.m_Data, 256);

    return (*this);
}

