/// Focused entry point for the fluent [BrZod] validation API.
///
/// Prefer this import when the application only needs the historical BrZod
/// surface and should not expose contracts, formatters, or geographic models.
library br_zod;

export 'all_br_validations.dart'
    show
        BrZod,
        BrZodCallback,
        BrZodResult,
        ILocaleBrZod,
        LocalePtBR,
        PasswordPolicy;
