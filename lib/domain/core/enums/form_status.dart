/// One of either [modified] or [unmodified].
///
/// Useful for tracking a form so that for example
/// error text is not shown until after the user
/// attempts to submit the form the first time.
enum FormStatus { modified, unmodified }
