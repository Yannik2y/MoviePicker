//
//  AboutView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// About view with proper TMDB attribution
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon and Title
                    VStack(spacing: 16) {
                        Image(systemName: "film.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.cyan)
                        
                        Text(L10n.About.appName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(L10n.About.appSubtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L10n.About.features)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        FeatureRow(icon: "scope", text: L10n.About.featureBondpicker)
                        FeatureRow(icon: "target", text: L10n.About.featureCustompicker)
                        FeatureRow(icon: "trophy.fill", text: L10n.About.featureDadmode)
                        FeatureRow(icon: "person.fill", text: L10n.About.featureActorfilter)
                        FeatureRow(icon: "globe", text: L10n.About.featureLanguages)
                    }
                    .padding(.horizontal)
                    
                    // TMDB Attribution
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L10n.About.dataSources)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image("tmdb_logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 16)
                                Text(L10n.About.movieData)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            // Required TMDB Attribution Text
                            Text(L10n.About.tmdbDisclaimer)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.leading, 28)
                                .italic()
                            
                            Text(L10n.About.tmdbAttribution)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.leading, 28)
                            
                            Link(L10n.About.tmdbVisit, destination: URL(string: "https://www.themoviedb.org")!)
                                .font(.caption)
                                .foregroundColor(.cyan)
                                .padding(.leading, 28)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Legal Notice
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.About.legal)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(L10n.About.legalDisclaimer)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(L10n.About.legalNoncommercial)
                            .font(.caption)
                            .foregroundColor(.green.opacity(0.8))
                            .padding(.top, 4)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
            }
            .background(Color.black)
            .navigationTitle(L10n.About.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
    }
}

/// Feature row component
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.cyan)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
