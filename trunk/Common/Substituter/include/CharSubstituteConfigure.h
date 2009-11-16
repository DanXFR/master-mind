///////////////////////////////////////////////////////////////////////////////
/// @file CharSubstituteConfigure.h
/// @brief Character Substitution Configuration Class of MasterMind.
///
/// Related Files:
/// @li CharSubstituteConfigure.cpp - Implementation
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

#ifndef _CHAR_SUBSTITUTE_CONFIGURE_H__
#define _CHAR_SUBSTITUTE_CONFIGURE_H__

#include <iostream>
#include <string>

class CharSubstituteConfigure
{
public:

    CharSubstituteConfigure
    (
        std::string scheme_,
        bool bCaseSensitive_,
        bool bKeepOriginal_,
        unsigned char unknownSymbol_
    );
    virtual ~CharSubstituteConfigure();

    virtual std::string name() const;

    unsigned char getChar(unsigned char inputChar_) const;

    CharSubstituteConfigure(const CharSubstituteConfigure &obj_);
    CharSubstituteConfigure & operator =(const CharSubstituteConfigure &obj_);

private:

    CharSubstituteConfigure();

    static const std::string m_Name;    // Name of the component

    unsigned char m_Data[256];
};

inline std::string CharSubstituteConfigure::name() const
{
    return m_Name;
}

inline unsigned char CharSubstituteConfigure::getChar(unsigned char inputChar_) const
{
    return m_Data[(int)inputChar_];
}

#endif // _CHAR_SUBSTITUTE_CONFIGURE_H__

