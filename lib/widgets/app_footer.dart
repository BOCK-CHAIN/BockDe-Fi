import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(40),
            child: Row(
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
                          fontSize: 16,
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
                      _buildFooterLink('About Us'),
                      _buildFooterLink('Employees & SOPs'),
                      _buildFooterLink('Progress'),
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
                          fontSize: 16,
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
                      _buildFooterLink('Bock Automotive'),
                      _buildFooterLink('Bock Foods'),
                      _buildFooterLink('Bock Space'),
                      _buildFooterLink('Bock AI'),
                      _buildFooterLink('Bock Health'),
                      _buildFooterLink('Bock Chain'),
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
                          fontSize: 16,
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
                      _buildFooterLink('Internships'),
                      _buildFooterLink('Procedure'),
                      _buildFooterLink('Recruitment'),
                      _buildFooterLink('Benefits'),
                      _buildFooterLink('Jobs'),
                      _buildFooterLink('FAQ\'s'),
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
                          fontSize: 16,
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
                      Row(
                        children: [
                          _buildSocialIcon(Icons.facebook, () {}),
                          _buildSocialIcon(Icons.web, () {}), // Twitter alternative
                          _buildSocialIcon(Icons.camera_alt, () {}), // Instagram alternative
                          _buildSocialIcon(Icons.work, () {}), // LinkedIn alternative
                          _buildSocialIcon(Icons.play_arrow, () {}), // YouTube alternative
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Back to Top
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            // Scroll to top logic
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Back To Top',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.keyboard_arrow_up,
                                color: Color(0xFF8B5CF6),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
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
              ],
            ),
          ),
          
          // Bottom Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Octakaigon Bock Private Limited',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF64B5F6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {},
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D4A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}