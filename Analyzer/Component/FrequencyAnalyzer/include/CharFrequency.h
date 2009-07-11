///////////////////////////////////////////////////////////////////////////////
/// @file CharFrequency.h
/// @brief Character Frequency Analyzer Class of MasterMind.
///
/// Related Files:
/// @li CharFrequency.cpp - Implementation
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

#ifndef _CHAR_FREQUENCY_H__
#define _CHAR_FREQUENCY_H__

#include <iostream>
#include <string>
#include <vector>
#include <map>

class CharFrequency
{
public:

    CharFrequency();
    virtual ~CharFrequency();

    virtual std::string name() const;

    virtual void process(std::istream &in_, bool bSkipWS_ = false, bool bCaseSensitive_ = false);

    void getAlnum(std::vector<std::pair<unsigned int, unsigned char> > &vMap_, bool bSorted_ = false);
    unsigned int getAlnum() const;
    unsigned int getPunct() const;
    unsigned int getSpace() const;
    unsigned int getCtrl() const;
    unsigned int getPrint() const;
    unsigned int getUnknown() const;

private: 

    void reset();

    static const std::string m_Name;  // Name of the component

    std::map<unsigned char, unsigned int> m_FreqAlnum;  // Frequency per alphanumeric character
    unsigned int m_FreqTotalAlnum;  // Frequency of alphanumeric characters
    unsigned int m_FreqPunct;       // Frequency of punctuation characters
    unsigned int m_FreqSpace;       // Frequency of white space characters
    unsigned int m_FreqCtrl;        // Frequency of control characters
    unsigned int m_FreqPrint;       // Frequency of all printable characters
    unsigned int m_FreqUnknown;     // Frequency of unknown characters
};

inline std::string CharFrequency::name() const
{
    return m_Name;
}

inline unsigned int CharFrequency::getAlnum() const
{
    return m_FreqTotalAlnum;
}

inline unsigned int CharFrequency::getPunct() const
{
    return m_FreqPunct;
}

inline unsigned int CharFrequency::getSpace() const
{
    return m_FreqSpace;
}

inline unsigned int CharFrequency::getCtrl() const
{
    return m_FreqCtrl;
}

inline unsigned int CharFrequency::getPrint() const
{
    return m_FreqPrint;
}

inline unsigned int CharFrequency::getUnknown() const
{
    return m_FreqUnknown;
}

#endif // _CHAR_FREQUENCY_H__

