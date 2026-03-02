import SwiftUI
import UIKit

// MARK: - Enums
enum AppTab {
    case home
    case feed
    case inbox
}

// MARK: - Model
struct StudyReel: Identifiable {
    let id = UUID()
    let author: String
    let handle: String
    let description: String
    let tipTitle: String
    let tipQuestion: String
    let tipCode: String
    let tipExplanation: String
    let likes: String
    let comments: String
    let gradientColors: [Color]
    
    // Quiz properties
    let hasQuiz: Bool
    let quizQuestion: String?
    let quizOptions: [String]?
    let correctOptionIndex: Int?
}

// MARK: - Chat Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let sender: String
    let text: String
    let isMe: Bool
    let isQuiz: Bool
    let options: [String]?
    let isGroupInvite: Bool
    let groupName: String?
    let groupMembers: Int?
}

// MARK: - Main View
struct ContentView: View {
    let reels: [StudyReel] = [
        StudyReel(
            author: "iOS Guru", handle: "@ios_guru",
            description: "Mastering UI in SwiftUI 🚀 Morphing from scrolling to addictive study reels... #StudyGram",
            tipTitle: "Swift Tip #42", tipQuestion: "How to create a sleek neon border in SwiftUI?",
            tipCode: "`.stroke(LinearGradient(...), lineWidth: 2)`",
            tipExplanation: "Pro-tip: Combine with `.ultraThinMaterial` for the perfect glassmorphism effect!",
            likes: "124K", comments: "4,213",
            gradientColors: [Color(red: 0.1, green: 0, blue: 0.25), Color(red: 0.0, green: 0.05, blue: 0.15), Color(red: 0.3, green: 0, blue: 0.3)],
            hasQuiz: true,
            quizQuestion: "Which modifier creates a glassmorphism effect in SwiftUI?",
            quizOptions: [".blur()", ".ultraThinMaterial", ".opacity(0.5)", ".glassMode()"],
            correctOptionIndex: 1
        ),
        StudyReel(
            author: "Code Ninja", handle: "@code_ninja",
            description: "Algorithms in 60s ⏱️ Today: Hash Maps #StudyGram #Coding",
            tipTitle: "DSA Tip #1", tipQuestion: "Why use a Hash Table?",
            tipCode: "O(1) average time complexity \nfor search, insert, delete.",
            tipExplanation: "Use it to map keys to values efficiently. Great for counting frequencies in arrays!",
            likes: "89K", comments: "1,024",
            gradientColors: [Color(red: 0.0, green: 0.15, blue: 0.3), Color(red: 0.0, green: 0.05, blue: 0.15), Color(red: 0.0, green: 0.2, blue: 0.1)],
            hasQuiz: true,
            quizQuestion: "What is the average time complexity for a Hash Map lookup?",
            quizOptions: ["O(n)", "O(log n)", "O(1)", "O(n^2)"],
            correctOptionIndex: 2
        ),
        StudyReel(
            author: "Design Pro", handle: "@design_pro",
            description: "Accessibility matters! Voice overlays and dynamic type 🗣️ #StudyGram",
            tipTitle: "App Tip #7", tipQuestion: "How to add VoiceOver support?",
            tipCode: "`.accessibilityLabel(\"Text\")`\n`.accessibilityAddTraits(.isButton)`",
            tipExplanation: "Always test with VoiceOver enabled. Great design includes everyone.",
            likes: "210K", comments: "8,991",
            gradientColors: [Color(red: 0.2, green: 0.0, blue: 0.1), Color(red: 0.1, green: 0.0, blue: 0.05), Color(red: 0.2, green: 0.1, blue: 0.2)],
            hasQuiz: false,
            quizQuestion: nil, quizOptions: nil, correctOptionIndex: nil
        )
    ]
    
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .home:
                    HomeFeedView(reels: reels)
                case .feed:
                    MyFeedView(reels: reels)
                case .inbox:
                    InboxView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Tab Bar
            HStack {
                Spacer()
                TabBarButton(icon: "house.fill", title: "Home", isSelected: selectedTab == .home) { selectedTab = .home }
                Spacer()
                TabBarButton(icon: "play.square.stack", title: "My Feed", isSelected: selectedTab == .feed) { selectedTab = .feed }
                Spacer()
                TabBarButton(icon: "tray.full.fill", title: "Inbox", isSelected: selectedTab == .inbox) { selectedTab = .inbox }
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 25)
            .background(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Tab Bar Button
struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption2)
                    .bold()
            }
            .foregroundColor(isSelected ? .cyan : .gray)
        }
    }
}

// MARK: - Home Feed View
struct HomeFeedView: View {
    let reels: [StudyReel]
    @State private var currentSelection = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { proxy in
                TabView(selection: $currentSelection) {
                    ForEach(reels.indices, id: \.self) { index in
                        ReelView(reel: reels[index])
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .rotationEffect(.degrees(-90))
                            .tag(index)
                    }
                }
                .frame(width: proxy.size.height, height: proxy.size.width)
                .rotationEffect(.degrees(90), anchor: .topLeading)
                .offset(x: proxy.size.width)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .ignoresSafeArea()
            
            HStack {
                Text("StudyGram")
                    .font(.custom("Avenir Next", size: 28, relativeTo: .title))
                    .fontWeight(.heavy)
                    .foregroundStyle(
                        LinearGradient(colors: [.blue, .purple, .pink], startPoint: .leading, endPoint: .trailing)
                    )
                Spacer()
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.title3)
                Text("14 Days")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .zIndex(10)
        }
    }
}

// MARK: - My Feed View
struct MyFeedView: View {
    let reels: [StudyReel]
    @State private var currentSelection = 0
    
    var subscribedReels: [StudyReel] {
        return reels.reversed()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { proxy in
                TabView(selection: $currentSelection) {
                    ForEach(subscribedReels.indices, id: \.self) { index in
                        ReelView(reel: subscribedReels[index])
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .rotationEffect(.degrees(-90))
                            .tag(index)
                    }
                }
                .frame(width: proxy.size.height, height: proxy.size.width)
                .rotationEffect(.degrees(90), anchor: .topLeading)
                .offset(x: proxy.size.width)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .ignoresSafeArea()
            
            HStack {
                Text("My Feed")
                    .font(.custom("Avenir Next", size: 28, relativeTo: .title))
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .zIndex(10)
        }
    }
}

// MARK: - Inbox View
struct InboxView: View {
    @State private var showingInviteSheet = false

    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showingInviteSheet = true
                }) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 50, height: 50)
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(.cyan)
                                .font(.title2)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Invite Friends")
                                .font(.headline)
                                .foregroundColor(.cyan)
                            Text("Study together and share reels!")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.black)
                .listRowSeparator(.hidden)
                
                NavigationLink(destination: ChatViewWrapper().navigationTitle("Study Group Chat")) {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 50, height: 50)
                            .overlay(Text("SG").bold().foregroundColor(.white))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Study Group Chat")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Alex: Let's see if you remember this...")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.black)
                .listRowSeparator(.hidden)
                
                NavigationLink(destination: ChatViewWrapper().navigationTitle("Alex")) {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Alex")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Are you reviewing the data structures tomorrow?")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.black)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Inbox")
            .background(Color.black.ignoresSafeArea())
            .sheet(isPresented: $showingInviteSheet) {
                InviteFriendsView()
            }
        }
    }
}

// MARK: - Invite Friends View
struct InviteFriendsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "envelope.open.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding(.top, 40)
                
                Text("Invite Your Friends")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Study together, share flashcards, and challenge each other in coding quizzes!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Button(action: {
                    let activityVC = UIActivityViewController(activityItems: ["Join me on StudyGram! https://studygram.app/invite"], applicationActivities: nil)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first,
                       let rootVC = window.rootViewController {
                        rootVC.present(activityVC, animated: true, completion: nil)
                    }
                }) {
                    Text("Share Invite Link")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer()
            }
            .background(Color(white: 0.05).ignoresSafeArea())
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title2)
            })
        }
        .preferredColorScheme(.dark)
    }
}

struct ChatViewWrapper: View {
    @State private var messages = [
        ChatMessage(sender: "You", text: "Whoa this is super helpful!", isMe: true, isQuiz: false, options: nil, isGroupInvite: false, groupName: nil, groupMembers: nil),
        ChatMessage(sender: "Alex", text: "Are you reviewing the data structures tomorrow?", isMe: false, isQuiz: false, options: nil, isGroupInvite: false, groupName: nil, groupMembers: nil),
        ChatMessage(sender: "Alex", text: "Join our cram session!", isMe: false, isQuiz: false, options: nil, isGroupInvite: true, groupName: "Midnight Algorithms 🌙", groupMembers: 4),
        ChatMessage(sender: "Alex", text: "Let's see if you remember this:", isMe: false, isQuiz: true, options: ["Array", "Linked List", "Hash Map"], isGroupInvite: false, groupName: nil, groupMembers: nil),
    ]
    
    var body: some View {
        ChatView(messages: $messages)
    }
}

// MARK: - Reel View
struct ReelView: View {
    let reel: StudyReel
    
    @State private var isFlipped = false
    @State private var showingPoseGuide = false
    @State private var isLiked = false
    @State private var showingQuiz = false
    @State private var selectedAnswerIndex: Int? = nil
    
    @State private var isSubscribed = false
    @State private var showingComments = false
    
    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    var body: some View {
        ZStack {
            backgroundLayer
            mainContent
            
            if showingQuiz {
                quizOverlay // Center Reel challenge
            }
            
            if showingPoseGuide {
                poseOverlay
            }
        }
        .sheet(isPresented: $showingComments) {
            CommentsSheetView()
                .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

extension ReelView {
    var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: reel.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Color.black.opacity(0.4)
                .ignoresSafeArea()
        }
    }
    
    var mainContent: some View {
        VStack {
            Spacer()
            flashCard
            Spacer()
            bottomSection
        }
        .padding(.top, 60)
        .blur(radius: showingQuiz ? 10 : 0)
    }
    
    var flashCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(colors: [.cyan, .purple],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing),
                            lineWidth: 2
                        )
                )
                .shadow(color: .purple.opacity(0.5), radius: 20)
            
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "swift")
                        .foregroundColor(.cyan)
                    
                    Text(reel.tipTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                if !isFlipped {
                    Text(reel.tipQuestion)
                        .foregroundColor(.white)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(reel.tipCode)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.cyan)
                        
                        Text(reel.tipExplanation)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(25)
        }
        .frame(height: 220)
        .padding(.horizontal, 20)
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0),
                          axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            triggerHaptic()
            withAnimation(.spring()) {
                isFlipped.toggle()
            }
        }
    }
    
    var bottomSection: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(reel.author) // Channel Name
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Button {
                        triggerHaptic()
                        withAnimation { isSubscribed.toggle() }
                    } label: {
                        Text(isSubscribed ? "Subscribed" : "Subscribe")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(isSubscribed ? Color.white.opacity(0.2) : Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                
                Text(reel.handle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(reel.description)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
            
            Spacer()
            
            actionButtons
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 90) // Added padding to avoid tab bar overlap
    }
    
    var actionButtons: some View {
        VStack(spacing: 25) {
            Button {
                triggerHaptic()
                withAnimation(.spring()) { isLiked.toggle() }
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 32))
                    .foregroundColor(isLiked ? .red : .white)
            }
            
            // Comments Button
            Button {
                triggerHaptic()
                showingComments = true
            } label: {
                Image(systemName: "text.bubble.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            if reel.hasQuiz {
                Button {
                    triggerHaptic(style: .rigid)
                    showingQuiz = true
                    selectedAnswerIndex = nil
                } label: {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.cyan)
                }
            }
            
            Button {
                showingPoseGuide.toggle()
            } label: {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 30))
                    .foregroundColor(showingPoseGuide ? .cyan : .white)
            }
        }
    }
    
    var quizOverlay: some View {
        Group {
            if let question = reel.quizQuestion,
               let options = reel.quizOptions,
               let correctIndex = reel.correctOptionIndex {
                
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture { showingQuiz = false }
                    
                    VStack(spacing: 20) {
                        Text(question)
                            .foregroundColor(.white)
                            .bold()
                        
                        ForEach(options.indices, id: \.self) { index in
                            Button {
                                if selectedAnswerIndex == nil {
                                    selectedAnswerIndex = index
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        showingQuiz = false
                                    }
                                }
                            } label: {
                                Text(options[index])
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .padding()
                }
            }
        }
    }
    
    var poseOverlay: some View {
        RoundedRectangle(cornerRadius: 150)
            .stroke(Color.cyan, style: StrokeStyle(lineWidth: 4, dash: [10, 10]))
            .frame(width: 250, height: 350)
            .overlay(
                Text("Align face here")
                    .foregroundColor(.cyan)
                    .offset(y: -200)
            )
            .transition(.opacity)
            .zIndex(2)
    }
}

// MARK: - Comments Sheet View
struct CommentsSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Comments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .padding()
            .background(Color(white: 0.1))
            
            Spacer()
            Text("No comments yet. Be the first to comment!")
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color(white: 0.05).ignoresSafeArea())
    }
}

// MARK: - Chat View (Inbox Conversation)
struct ChatView: View {
    @Binding var messages: [ChatMessage]
    @State private var newMessage = ""
    @Environment(\.dismiss) var dismiss
    @State private var joinedGroups: Set<UUID> = []
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isMe { Spacer() }
                            
                            if message.isGroupInvite, let groupName = message.groupName, let members = message.groupMembers {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "person.3.fill")
                                            .foregroundColor(.cyan)
                                        Text("Study Group Invite")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .textCase(.uppercase)
                                            .foregroundColor(.cyan)
                                    }
                                    
                                    Text(groupName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text("\(members) members active now")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Button(action: {
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        withAnimation {
                                            if joinedGroups.contains(message.id) {
                                                joinedGroups.remove(message.id)
                                            } else {
                                                joinedGroups.insert(message.id)
                                            }
                                        }
                                    }) {
                                        Text(joinedGroups.contains(message.id) ? "Joined! ✅" : "Join Group")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(
                                                joinedGroups.contains(message.id)
                                                ? Color.green.opacity(0.3)
                                                : Color.cyan.opacity(0.3)
                                            )
                                            .foregroundColor(joinedGroups.contains(message.id) ? .green : .cyan)
                                            .cornerRadius(12)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(white: 0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(LinearGradient(colors: [.cyan.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                                        )
                                )
                                .frame(maxWidth: 250, alignment: message.isMe ? .trailing : .leading)
                                
                            } else if message.isQuiz, let options = message.options {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("\(message.sender) challenged you: \(message.text)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    
                                    ForEach(options, id: \.self) { option in
                                        Button(action: {
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        }) {
                                            Text(option)
                                                .font(.caption)
                                                .padding(8)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.white.opacity(0.2))
                                                .cornerRadius(10)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding()
                                .background(LinearGradient(colors: [.purple, .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(16)
                                .frame(maxWidth: 250, alignment: message.isMe ? .trailing : .leading)
                                
                            } else {
                                Text(message.text)
                                    .padding(12)
                                    .background(message.isMe ? Color.blue.opacity(0.8) : Color(white: 0.15))
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                    .frame(maxWidth: 250, alignment: message.isMe ? .trailing : .leading)
                            }
                            
                            if !message.isMe { Spacer() }
                        }
                    }
                }
                .padding()
            }
            .background(Color.black)
            
            // Input Area
            HStack(spacing: 12) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    messages.append(ChatMessage(sender: "You", text: "Join my new group!", isMe: true, isQuiz: false, options: nil, isGroupInvite: true, groupName: "SwiftUI Masterclass 💻", groupMembers: 1))
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.cyan)
                        .font(.title2)
                }
                
                TextField("Message, Quiz (?), or Invite...", text: $newMessage)
                    .padding(12)
                    .background(Color(white: 0.15))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
                Button(action: {
                    if !newMessage.isEmpty {
                        if newMessage.starts(with: "?") {
                            let parts = newMessage.dropFirst().split(separator: "?")
                            if parts.count == 2 {
                                let q = String(parts[0])
                                let opts = parts[1].split(separator: ",").map { String($0) }
                                messages.append(ChatMessage(sender: "You", text: q, isMe: true, isQuiz: true, options: opts, isGroupInvite: false, groupName: nil, groupMembers: nil))
                            }
                        } else {
                            messages.append(ChatMessage(sender: "You", text: newMessage, isMe: true, isQuiz: false, options: nil, isGroupInvite: false, groupName: nil, groupMembers: nil))
                        }
                        newMessage = ""
                    }
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .foregroundColor(newMessage.isEmpty ? .gray : .cyan)
                        .font(.title)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
            .background(Color(white: 0.1))
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
