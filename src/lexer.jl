# A Lexer / Tokenizer for tokens found in plists

# Token types
@enum(TokenType,
    NUMBER    = 1,
    STRING    = 2,
    HEXBINARY = 3,
    UNKNOWN   = 4,
    EOF       = 6,
    LPAREN = Int('('),
    RPAREN = Int(')'),
    LBRACE = Int('{'),
    RBRACE = Int('}'),
    COMMA  = Int(','),
    EQUAL  = Int('='),
    SEMICOLON = Int(';'))

# Allows TokenType(char) and Char(tokentype) constructors needed by show() 
import Base.convert
convert(::Type{TokenType}, ch::Char) = TokenType(Int(ch))
convert(::Type{Char}, t::TokenType)  = Char(Int(t))

# mapping from token type to a string representation
const token_name = Dict(NUMBER  => "Number", 
                        STRING  => "String", 
                        UNKNOWN => "Unknown", 
                        EOF     => "EOF",
                        HEXBINARY => "Binary")

"""
A string of code is turned into an array of Tokens by the lexer. Each
symbol or word in code is represented as a Token.
"""
struct Token
    kind::TokenType
    lexeme::String
end

function Token(kind::TokenType)
    lexeme = ""
    if !haskey(token_name, kind)
       lexeme = string(Char(kind))
    end
    Token(kind, lexeme)
end

function show(io::IO, token::Token)  # avoids recursion into prev and next
    token_str = if haskey(token_name, token.kind)
        token_name[token.kind]
    else
        string(Char(token.kind))
    end

    lex_str = if token.lexeme != "" && token.lexeme != string(Char(token.kind))
        "($(token.lexeme))"
    else
        ""
    end
    print(io, "$token_str $lex_str")
end

==(t1::Token, t2::Token) = t1.kind == t2.kind && t1.lexeme == t2.lexeme

"Keeps track of string of code we want to turn into array of tokens"
mutable struct Lexer
   buffer::String
end

# define iterator interface to tokens in lexer. Requires
# implementation of start, done and next
start(lex::Lexer) = 1
done(lex::Lexer, pos::Int) = length(lex.buffer) < pos
iteratorsize(lex::Lexer) =  Base.SizeUnknown()

function next(lex::Lexer, pos::Int)
    if done(lex, pos)
        return (Token(EOF, ""), pos)
    end

    buf = lex.buffer
    ch = buf[pos]

    while ch in " \t\n"
        pos += 1
        if done(lex, pos)
            return (Token(EOF, ""), pos)
        end
        ch = buf[pos]
    end

    if in(ch, "{}(),=;")
        (Token(TokenType(ch), string(ch)), pos + 1)
    elseif isdigit(ch)
        range = search(buf, r"\d+", pos)
        (Token(NUMBER, buf[range]), last(range) + 1)
    elseif ch == '"'
        npos = search(buf, '"', pos + 1) # TODO: Does not handle escaped quotes
        (Token(STRING, buf[pos + 1:npos-1]), npos + 1)
    elseif ch == '<'
        npos = search(buf, '>', pos + 1)
        (Token(HEXBINARY, buf[pos + 1:npos-1]), npos + 1)
    elseif isalpha(ch)
        range = search(buf, r"\w+", pos)
        (Token(STRING, buf[range]), last(range) + 1)
    else
        error("Unknown character '$ch' at position: $(pos)")
    end
end
