# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development
- `pnpm dev` - Run the development server with Turbopack (runs on http://localhost:3000)
- `pnpm build` - Build the production application
- `pnpm start` - Start the production server

### Database
- `pnpm db:setup` - Create the .env file with database configuration
- `pnpm db:generate` - Generate Drizzle migrations from schema changes
- `pnpm db:migrate` - Apply database migrations
- `pnpm db:seed` - Seed database with test user (test@test.com / admin123)
- `pnpm db:studio` - Open Drizzle Studio for database management

### Stripe Webhooks (Local Development)
- `stripe listen --forward-to localhost:3000/api/stripe/webhook` - Listen for Stripe webhook events locally

## Architecture

### Tech Stack
- **Framework**: Next.js 15.4 with App Router
- **Database**: PostgreSQL with Drizzle ORM
- **Authentication**: JWT-based with cookies (custom implementation)
- **Payments**: Stripe (subscriptions and customer portal)
- **UI**: shadcn/ui components with Radix UI primitives
- **Styling**: Tailwind CSS v4

### Database Schema
The application uses Drizzle ORM with PostgreSQL. Key tables:
- `users` - User accounts with email/password authentication
- `teams` - Organizations with Stripe subscription data
- `teamMembers` - Many-to-many relationship with roles (owner/member)
- `activityLogs` - Audit trail for all user actions
- `invitations` - Pending team invitations

Schema definitions and types are in `lib/db/schema.ts`. Database queries are centralized in `lib/db/queries.ts`.

### Authentication Flow
- JWT tokens stored in httpOnly cookies (session management in `lib/auth/session.ts`)
- Global middleware (`middleware.ts`) protects `/dashboard/*` routes
- Session tokens are automatically refreshed on GET requests
- Local middleware functions for Server Actions validation:
  - `validatedAction` - Validates form data with Zod schemas
  - `validatedActionWithUser` - Adds authenticated user to action context
  - `withTeam` - Ensures user has team access

### Routing Structure
- `/(login)` - Authentication pages (sign-in, sign-up)
- `/dashboard` - Protected dashboard area with nested layouts
  - Team management, activity logs, security settings
- `/pricing` - Stripe product/price display and checkout
- `/api/stripe` - Webhook handlers for subscription events

### Key Patterns
1. **Server Actions**: Form submissions use Server Actions with Zod validation
2. **Data Fetching**: Server Components fetch data directly in components
3. **Protected Routes**: Middleware handles authentication redirects
4. **Activity Logging**: All user actions are tracked via `logActivity` function
5. **Role-Based Access**: Owner/Member roles enforced at action level

### Environment Variables Required
- `POSTGRES_URL` - PostgreSQL connection string
- `AUTH_SECRET` - JWT signing secret (generate with `openssl rand -base64 32`)
- `BASE_URL` - Application URL (e.g., http://localhost:3000)
- `STRIPE_SECRET_KEY` - Stripe API secret key
- `STRIPE_WEBHOOK_SECRET` - Stripe webhook endpoint secret
- `STRIPE_PUBLISHABLE_KEY` - Stripe publishable key (client-side)
- `APPFIGURES_PERSONAL` - Appfigures API Personal Access Token (Bearer token for reviews API)

### Testing Credentials
Default seed user:
- Email: `test@test.com`
- Password: `admin123`

Test Stripe card:
- Number: `4242 4242 4242 4242`
- Expiry: Any future date
- CVC: Any 3 digits

### Important Implementation Notes
- Next.js experimental features enabled: PPR, clientSegmentCache, nodeMiddleware
- All imports use `@/` path alias (configured in tsconfig.json)
- Stripe API version: `2025-04-30.basil`
- TypeScript strict mode enabled
- No testing framework currently configured



# Claude Code Spec-Driven Development

Kiro-style Spec Driven Development implementation using claude code slash commands, hooks and agents.

## Project Context

### Paths
- Steering: `.kiro/steering/`
- Specs: `.kiro/specs/`
- Commands: `.claude/commands/`

### Steering vs Specification

**Steering** (`.kiro/steering/`) - Guide AI with project-wide rules and context  
**Specs** (`.kiro/specs/`) - Formalize development process for individual features

### Active Specifications
- `reviews-search-filter` - Real-time search and filtering interface for app reviews with keyword search and star rating filters (COMPLETED)
- `review-data-views` - Advanced UI components for displaying review data in multiple formats including table view, grid view, sentiment timeline, and additional visualization options (COMPLETED)
- `reviews-dashboard-revamp` - Transform reviews page into comprehensive dashboard with Home (table/grid/classic views) and Analytics (timeline/analytics views) pages using existing dashboard structure as template
- `reviews-rating-filter` - Advanced search and rating filter functionality for reviews with real-time updates and API integration
- Check `.kiro/specs/` for active specifications
- Use `/kiro:spec-status [feature-name]` to check progress

## Development Guidelines
- Think in English and generate responses in English

## Workflow

### Phase 0: Steering (Optional)
`/kiro:steering` - Create/update steering documents
`/kiro:steering-custom` - Create custom steering for specialized contexts

**Note**: Optional for new features or small additions. Can proceed directly to spec-init.

### Phase 1: Specification Creation
1. `/kiro:spec-init [detailed description]` - Initialize spec with detailed project description
2. `/kiro:spec-requirements [feature]` - Generate requirements document
3. `/kiro:spec-design [feature]` - Interactive: "requirements [y/N]"
4. `/kiro:spec-tasks [feature]` - Interactive: Confirms both requirements and design review

### Phase 2: Progress Tracking
`/kiro:spec-status [feature]` - Check current progress and phases

## Development Rules
1. **Consider steering**: Run `/kiro:steering` before major development (optional for new features)
2. **Follow 3-phase approval workflow**: Requirements → Design → Tasks → Implementation
3. **Approval required**: Each phase requires human review (interactive prompt or manual)
4. **No skipping phases**: Design requires approved requirements; Tasks require approved design
5. **Update task status**: Mark tasks as completed when working on them
6. **Keep steering current**: Run `/kiro:steering` after significant changes
7. **Check spec compliance**: Use `/kiro:spec-status` to verify alignment

## Steering Configuration

### Current Steering Files
Managed by `/kiro:steering` command. Updates here reflect command changes.

### Active Steering Files
- `product.md`: Always included - Product context and business objectives
- `tech.md`: Always included - Technology stack and architectural decisions
- `structure.md`: Always included - File organization and code patterns

### Custom Steering Files
<!-- Added by /kiro:steering-custom command -->
<!-- Format: 
- `filename.md`: Mode - Pattern(s) - Description
  Mode: Always|Conditional|Manual
  Pattern: File patterns for Conditional mode
-->

### Inclusion Modes
- **Always**: Loaded in every interaction (default)
- **Conditional**: Loaded for specific file patterns (e.g., `"*.test.js"`)
- **Manual**: Reference with `@filename.md` syntax