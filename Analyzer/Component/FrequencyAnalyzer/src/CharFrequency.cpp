///////////////////////////////////////////////////////////////////////////////
/// @file CharFrequency.cpp
/// @brief Character Frequency Analyzer of MasterMind.
///
/// Related Files:
/// @li CharFrequency.h - Declaration
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
#include <locale>
#include <algorithm>
#include "CharFrequency.h"

const std::string CharFrequency::m_Name = "Character Frequency Analyzer";

CharFrequency::CharFrequency()
{
    reset();
}

CharFrequency::~CharFrequency()
{
    reset();
}

void CharFrequency::process(std::istream &in_, bool bSkipWS_, bool bCaseSensitive_)
{
    reset();

    if (bSkipWS_)
    {
        in_.setf(std::ios::skipws);
    }
    else
    {
        in_.unsetf(std::ios::skipws);
    }

    unsigned char c;

    while (EOF != in_.peek())
    {
        in_ >> c;

        if (iscntrl(c))
        {
            m_FreqCtrl++;
        }
        else if (isprint(c))
        {
            m_FreqPrint++;

            if (!bCaseSensitive_ && islower(c))
            {
                c = std::toupper(c);
            }

            if (isalnum(c))
            {
                m_FreqTotalAlnum++;

                std::map<unsigned char, unsigned int>::const_iterator iter;

                iter = m_FreqAlnum.find(c);

                if (m_FreqAlnum.end() == iter)
                {
                    m_FreqAlnum.insert(std::pair<unsigned char, unsigned int>(c, 1));
                }
                else
                {
                    m_FreqAlnum[c]++;
                }
            }
            else if (ispunct(c))
            {
                m_FreqPunct++;
            }
            else if (isspace(c))
            {
                m_FreqSpace++;
            }
            else
            {
                m_FreqUnknown++;
            }
        }
        else
        {
            m_FreqUnknown++;
        }
    }
}

void CharFrequency::getAlnum(std::vector<std::pair<unsigned int, unsigned char> > &vMap_, bool bSorted_)
{
    std::map<unsigned char, unsigned int>::const_iterator iter;

    for (iter = m_FreqAlnum.begin(); iter != m_FreqAlnum.end(); iter++)
    {
        vMap_.push_back(std::pair<unsigned int, unsigned char>(iter->second, iter->first));
    }

    if (bSorted_)
    {
        std::sort(vMap_.begin(), vMap_.end());
        std::reverse(vMap_.begin(), vMap_.end());
    }
}

void CharFrequency::reset()
{
    m_FreqAlnum.clear();

    m_FreqTotalAlnum = 0;
    m_FreqPunct      = 0;
    m_FreqSpace      = 0;
    m_FreqCtrl       = 0;
    m_FreqPrint      = 0;
    m_FreqUnknown    = 0;
}

