import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;
    final bool isTablet = MediaQuery.of(context).size.width < 1024;
    
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        border: Border(
          top: BorderSide(
            color: Color(0xFF2D2D4A),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Main Footer Content
          Container(
            padding: EdgeInsets.all(isMobile ? 20 : 40),
            child: isMobile ? _buildMobileFooter() : _buildDesktopFooter(isTablet),
          ),
          
          // Bottom Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40, 
              vertical: isMobile ? 16 : 20,
            ),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF2D2D4A),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '© 2024 BOCK. All Rights Reserved',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.white54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Octakaigon Bock Private Limited',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 12 : 14,
                    color: const Color(0xFF64B5F6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      children: [
        // First Row - Company & Businesses (horizontal)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMobileSection('Company', [
              'About Us',
              'Employees & SOPs',
              'Progress',
            ])),
            const SizedBox(width: 20),
            Expanded(child: _buildMobileSection('Businesses', [
              'Bock Automotive',
              'Bock Foods',
              'Bock Space',
              'Bock AI',
              'Bock Health',
              'Bock Chain',
            ])),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Second Row - Join Us & Follow Us (horizontal)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMobileSection('Join Us', [
              'Internships',
              'Procedure',
              'Recruitment',
              'Benefits',
              'Jobs',
              'FAQ\'s',
            ])),
            const SizedBox(width: 20),
            Expanded(child: _buildMobileFollowUsSection()),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopFooter(bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 15 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 3,
                width: 40,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  ),
                ),
              ),
              _buildFooterLink('About Us', isTablet),
              _buildFooterLink('Employees & SOPs', isTablet),
              _buildFooterLink('Progress', isTablet),
            ],
          ),
        ),
        
        // Businesses Section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Businesses',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 15 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 3,
                width: 40,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  ),
                ),
              ),
              _buildFooterLink('Bock Automotive', isTablet),
              _buildFooterLink('Bock Foods', isTablet),
              _buildFooterLink('Bock Space', isTablet),
              _buildFooterLink('Bock AI', isTablet),
              _buildFooterLink('Bock Health', isTablet),
              _buildFooterLink('Bock Chain', isTablet),
            ],
          ),
        ),
        
        // Join Us Section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join Us',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 15 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 3,
                width: 40,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  ),
                ),
              ),
              _buildFooterLink('Internships', isTablet),
              _buildFooterLink('Procedure', isTablet),
              _buildFooterLink('Recruitment', isTablet),
              _buildFooterLink('Benefits', isTablet),
              _buildFooterLink('Jobs', isTablet),
              _buildFooterLink('FAQ\'s', isTablet),
            ],
          ),
        ),
        
        // Follow Us Section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow Us',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 15 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 3,
                width: 40,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  ),
                ),
              ),
              
              // Social Media Icons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSocialIcon(Icons.facebook, () {}, isTablet),
                  _buildSocialIcon(Icons.web, () {}, isTablet), // Twitter alternative
                  _buildSocialIcon(Icons.camera_alt, () {}, isTablet), // Instagram alternative
                  _buildSocialIcon(Icons.work, () {}, isTablet), // LinkedIn alternative
                  _buildSocialIcon(Icons.play_arrow, () {}, isTablet), // YouTube alternative
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Back to Top
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Scroll to top logic
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Back To Top',
                            style: GoogleFonts.inter(
                              fontSize: isTablet ? 13 : 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: const Color(0xFF8B5CF6),
                            size: isTablet ? 18 : 20,
                          ),
                        ],
                      ),
                      Container(
                        height: 2,
                        width: 80,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileSection(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Container(
          height: 2,
          width: 30,
          margin: const EdgeInsets.only(top: 6, bottom: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
            ),
          ),
        ),
        ...links.map((link) => _buildMobileFooterLink(link)),
      ],
    );
  }

  Widget _buildMobileFollowUsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Container(
          height: 2,
          width: 30,
          margin: const EdgeInsets.only(top: 6, bottom: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
            ),
          ),
        ),
        
        // Social Media Icons - 2 rows for mobile
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSocialIcon(Icons.facebook, () {}, true),
            _buildSocialIcon(Icons.web, () {}, true),
            _buildSocialIcon(Icons.camera_alt, () {}, true),
            _buildSocialIcon(Icons.work, () {}, true),
            _buildSocialIcon(Icons.play_arrow, () {}, true),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Back to Top
        GestureDetector(
          onTap: () {
            // Scroll to top logic
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Back To Top',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.keyboard_arrow_up,
                    color: Color(0xFF8B5CF6),
                    size: 16,
                  ),
                ],
              ),
              Container(
                height: 2,
                width: 60,
                margin: const EdgeInsets.only(top: 3),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {},
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: isTablet ? 13 : 14,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialIcon(IconData icon, VoidCallback onTap, bool isCompact) {
    final double size = isCompact ? 32 : 36;
    final double iconSize = isCompact ? 16 : 18;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D4A),
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Icon(
            icon,
            color: Colors.white70,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}